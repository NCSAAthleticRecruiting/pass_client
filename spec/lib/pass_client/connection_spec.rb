require 'pass_client/connection'
require 'pass_client/configuration'
require 'rack/test'
require 'ostruct'

RSpec.describe PassClient::Connection do
  let(:config_data) { PassClient.configuration }
  before do
    ENV['PASS_CLIENT_ENV'] = 'test'
  end

  describe '#initialize' do
    it 'returns an instance with the environment config loaded' do
      subject = described_class.new(:test)

      expect(subject.hostname).to eq(config_data.hostname)
      expect(subject.timeout).to eq(config_data.timeout)
      expect(subject.auth_id).to eq(config_data.auth_id)
      expect(subject.secret_key).to eq(config_data.secret_key)
    end

    it 'takes an optional initialization hash' do
      PassClient.configure do |config|
        config.hostname = "http://localtest"
        config.timeout = 2222
        config.auth_id = "my_test_auth"
        config.secret_key = "my_secret"
        config.port = 844
      end
      subject = described_class.new(:test)

      expect(subject.hostname).to eq("http://localtest")
      expect(subject.timeout).to eq(2222)
      expect(subject.auth_id).to eq("my_test_auth")
      expect(subject.secret_key).to eq("my_secret")
      expect(subject.port).to eq(844)
    end
  end

  describe "#connection" do
    subject { described_class.new(:test) }

    it 'creates a new Faraday::Connection object ' do
      expect(subject.connection).to be_instance_of(Faraday::Connection)
    end

    context 'when creating a new Faraday::Connection object' do
      let(:faraday_fake) { instance_spy('Faraday::Connection') }

      before do
        allow(Faraday).to receive(:new).and_yield(faraday_fake)
      end

      it 'sets the connection to use HMAC' do
        subject.connection

        expect(faraday_fake)
          .to have_received(:use)
          .with(:hmac, config_data.auth_id, config_data.secret_key, sign_with: :sha256)
      end
    end
  end

  describe 'HMAC signing of requests' do
    let(:stub_app) do
      ->(env) do
        authenticated = Ey::Hmac.authenticated?(
          env,
          accept_digests: [:sha256, :sha512],
          adapter: Ey::Hmac::Adapter::Rack
        ) { |auth_id| (auth_id == @auth_id) && @secret_key}

        [(authenticated ? 200 : 401), {"Content-Type" => "text/plain"}, []]
      end
    end

    subject do
      described_class.new(:test, rack_app: stub_app)
    end

    it 'configures signing of successful requests' do
      @auth_id = subject.auth_id
      @secret_key = subject.secret_key

      expect(subject.get("/resources").status).to eq(200)
    end

    it 'fails when request is not signed with the correct auth_id' do
      @auth_id = 'its_bogus'
      @secret_key = subject.secret_key

      expect { subject.get("/resources") }.to raise_error(PassClient::ResponseError)
    end

    it 'fails when request is not signed with the correct secret_key' do
      @auth_id = subject.auth_id
      @secret_key = 'it_bogus'

      expect { subject.get("/resources") }.to raise_error(PassClient::ResponseError)
    end
  end

  context 'when submitting a request' do
    subject do
      described_class.new(:test)
    end

    let(:faraday_mock)    { double(Faraday::Connection) }
    let(:config_spy) { instance_spy('config') }
    let(:faraday_response) { OpenStruct.new(status: 200) }

    let(:url)     { :some_url }
    let(:headers) { [] }
    let(:body)    { :body }
    let(:params)  { {some: :params} }
    let(:headers) { {one: :header} }

    before do
      allow(Faraday)
        .to receive(:new)
        .and_return(faraday_mock)

      allow(config_spy)
        .to receive(:options)
        .and_return(config_spy)

      allow(config_spy)
        .to receive(:headers)
        .and_return(headers)
    end

    [:get, :delete, :head].each do |verb|
      before do
        allow(faraday_mock)
          .to receive(verb)
          .and_yield(config_spy)
          .and_return(faraday_response)
      end

      it "##{verb} delegates to Faraday with url, params and headers" do
        expect(faraday_mock).to receive(verb).with(url, params, headers)

        subject.send(verb, url, params, headers)
      end

      it "##{verb} returns an ApiClient::Response object" do
        allow(faraday_mock).to receive(verb).and_return(faraday_response)
        response = subject.send(verb, url)

        expect(response).to be_instance_of(PassClient::Response)
      end

      it "##{verb} configures the request with timeouts" do
        subject.send(verb, url)

        expect(config_spy).to have_received(:options).exactly(2).times
        expect(config_spy).to have_received(:timeout=).with(config_data.timeout)
        expect(config_spy).to have_received(:open_timeout=).with(config_data.open_timeout)
      end

      it "##{verb} sets the content type" do
        subject.send(verb, url)

        expect(config_spy).to have_received(:headers)
        expect(headers['Content-Type']).to eq('application/json')
      end
    end

    [:post, :put, :patch].each do |verb|
      before do
        allow(faraday_mock)
          .to receive(verb)
          .and_yield(config_spy)
          .and_return(faraday_response)
      end

      it "delegates a #{verb} to Faraday with url, body, and headers" do
        subject.send(verb, url, body, headers)

        expect(faraday_mock).to have_received(verb).with(url, body, headers)
      end

      it "#{verb} returns an ApiClient::Response object" do
        allow(faraday_mock).to receive(verb).and_return(faraday_response)
        response = subject.send(verb, url)

        expect(response).to be_instance_of(PassClient::Response)
      end

      it 'configures the request with timeouts' do
        subject.send(verb, url)

        expect(config_spy).to have_received(:options).exactly(2).times
        expect(config_spy).to have_received(:timeout=).with(config_data.timeout)
        expect(config_spy).to have_received(:open_timeout=).with(config_data.open_timeout)
      end

      it "##{verb} sets the content type" do
        subject.send(verb, url)

        expect(config_spy).to have_received(:headers)
        expect(headers['Content-Type']).to eq('application/json')
      end
    end
  end

  describe PassClient::Response do
    describe '#status' do
      it 'raises an PassClient::RequestError for 404' do
        expect do
          PassClient::Response.new(OpenStruct.new(status: 404)).status
        end.to raise_error(PassClient::ResponseError)
      end

      it 'raises an PassClient::RequestError for 500' do
        expect do
          PassClient::Response.new(OpenStruct.new(status: 500)).status
        end.to raise_error(PassClient::ResponseError)
      end

      it 'returns the status code for 200' do
        expected_status = 200
        resulting_status = PassClient::Response.new(OpenStruct.new(status: expected_status)).status

        expect(resulting_status).to eq(expected_status)
      end

      it 'returns the status code for 201' do
        expected_status = 201
        resulting_status = PassClient::Response.new(OpenStruct.new(status: expected_status)).status

        expect(resulting_status).to eq(expected_status)
      end
    end
  end
end
