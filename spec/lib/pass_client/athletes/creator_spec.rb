require 'pass_client/athletes/creator'

RSpec.describe PassClient::Athlete::Creator do
  subject { described_class.new(body: update_body) }

  let(:token_manager_double) { instance_double(PassClient::TokenManager) }
  let(:connection_double) { instance_double(PassClient::Connection) }
  let(:id) { "123-abc-456" }
  let(:update_body) { { email:"test@school.edu",sport_id:101} }
  let(:api_response) { Faraday::Response.new(status: 200, body: "") }
  let(:method) { :post }
  let(:token) { "atoken" }

  before do
    ENV['PASS_CLIENT_ENV'] = 'test'
    allow(PassClient::TokenManager).to receive(:new).and_return(token_manager_double)
    allow(token_manager_double).to receive(:renew!).and_return(token)
    allow(token_manager_double).to receive(:token!).and_return(token)
    allow(PassClient::Connection)
      .to receive(:unsigned_instance)
      .and_return(connection_double)
    allow(connection_double)
      .to receive(method)
      .and_return(api_response)
    ::PassClient.configuration.token = token
  end

  it 'sends a request to the correct address and accept a hash for update_body' do
    subject = described_class.new(body: { email: "test@school.edu", sport_id: 101 })
    expect(connection_double)
      .to receive(method).with(url: "/api/partner_athlete_search/v1/athlete/", body: {athlete: update_body}.to_json, headers: anything)

    subject.create!
  end

  it 'sets the authorization header' do
    expect(::PassClient.configuration.token).to eq "atoken"
    subject = described_class.new(body: { email: "test@school.edu", sport_id: 101 })
    expect(connection_double)
      .to receive(method).with(url: "/api/partner_athlete_search/v1/athlete/", body: {athlete: update_body}.to_json, headers: {authorization: token})

    subject.create!
  end

  context "with api responses" do
  let(:api_response) { Faraday::Response.new(status: 200, body: response_body) }
    let(:response_body) do
      {'data' =>
        { 'id' => id, 'attributes' => "All Athlete Data", 'type' => "Athlete"}
      }.to_json
    end

    it 'returns the response object' do
      expect(connection_double)
        .to receive(method)
        .and_return(api_response)

      response = subject.create!
      expect(response.status).to eq 200
      expect(response.body).to eq response_body
    end

    it 'renew the jwt ONCE when the status == 401' do
      ::PassClient.configuration.token = token
      api_response = Faraday::Response.new(status: 401, body: "Error")
      expect(connection_double)
        .to receive(method)
        .and_return(api_response)
        .exactly(2).times

      allow(subject).to receive(:token).and_return(token)
      expect{ subject.create! }.to raise_error(PassClient::Athlete::RequestError)
    end


    it 'raises a RequestError when the status == 404' do
      api_response = Faraday::Response.new(status: 404, body: "Error")
      expect(connection_double)
        .to receive(method)
        .and_return(api_response)

      expect{ subject.create! }.to raise_error(PassClient::Athlete::RequestError)
    end

    it 'raises a RequestError when the status == 301' do
      api_response = Faraday::Response.new(status: 301, body: "Error")
      expect(connection_double)
        .to receive(method)
        .and_return(api_response)

      expect{ subject.create! }.to raise_error(PassClient::Athlete::RequestError)
    end
  end
end
