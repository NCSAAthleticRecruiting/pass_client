require 'pass_client/token_manager'
require 'json'

RSpec.describe PassClient::TokenManager do
  subject { described_class.new }
  before do
    ::PassClient.reset
    allow(PassClient::Connection)
      .to receive(:instance)
      .and_return(connection_double)
    allow(connection_double)
      .to receive(:post)
      .and_return(api_response)
  end

  let(:connection_double) { instance_double(PassClient::Connection) }
  let(:auth_id) { ::PassClient.configuration.auth_id }
  let(:api_response) { Faraday::Response.new(status: 200, body: response_body.to_json) }
  let(:response_body) do
    {'data' =>
      { 'id' => auth_id, 'attributes' => { 'token' => "secret_json_web_token" }, 'type' => "Athlete"}
    }
  end
  let(:unauthorized) { Faraday::Response.new(status: 401, body: "Not Allowed!") }

  it 'returns the token' do
    expect(::PassClient.configuration.token).to eq ""
    expect(connection_double)
      .to receive(:post)
      .and_return(api_response)

    token = subject.token!
    expect(token).to eq "secret_json_web_token"
    expect(::PassClient.configuration.token).to eq "secret_json_web_token"
  end

  context "unauthorized" do
    before do
      allow(PassClient::Connection)
        .to receive(:instance)
        .and_return(connection_double)
      allow(connection_double)
        .to receive(:post)
        .and_return(unauthorized)
    end
    it 'raises an error on status == 401' do
      expect{ subject.token! }.to raise_error described_class::RequestError
    end
  end

  describe "#renew!" do
    before do
      ::PassClient.configuration.token = "an existing token"
    end

    it 'fetches and sets a new token ' do
      expect(::PassClient.configuration.token).to eq "an existing token"
      expect(subject.token!).to eq "an existing token"
      subject.renew!
      expect(::PassClient.configuration.token).to eq "secret_json_web_token"
    end

    it 'handles 401 ' do
      allow(connection_double)
        .to receive(:post)
        .and_return(unauthorized)
      expect{ subject.renew! }.to raise_error described_class::RequestError
    end
  end
end
