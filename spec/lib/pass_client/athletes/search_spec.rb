require 'pass_client/athletes/getter'

RSpec.describe PassClient::Athlete::Search do
  subject { described_class.new(search_terms: search_terms) }

  let(:token_manager_double) { instance_double(PassClient::TokenManager) }
  let(:connection_double) { instance_double(PassClient::Connection) }
  let(:search_terms) { { first_name: "Test", last_name: "Athlete" } }
  let(:api_response) { Faraday::Response.new(status: 200, body: "Search Results") }
  let(:method) { :get }
  let(:token) { "atoken" }

  before do
    allow(PassClient::TokenManager).to receive(:new).and_return(token_manager_double)
    allow(token_manager_double).to receive(:renew!).and_return(token)
    allow(token_manager_double).to receive(:token!).and_return(token)
    allow(PassClient::Connection)
      .to receive(:unsigned_instance)
      .and_return(connection_double)
    allow(connection_double)
      .to receive(method)
      .and_return(api_response)
  end

  it 'sends a request to the correct address' do
    expect(connection_double)
      .to receive(method).with(url: "/api/partner_athlete_search/v1/search/athlete", params: search_terms, headers: {authorization: token})

    subject.get
  end

  context "with api responses" do
    it 'renew the jwt ONCE when the status == 401' do
      ::PassClient.configuration.token = token
      api_response = Faraday::Response.new(status: 401, body: "Error")
      expect(connection_double)
        .to receive(method)
        .and_return(api_response)
        .exactly(2).times

      allow(subject).to receive(:token).and_return(token)
      expect{ subject.get }.to raise_error(PassClient::Athlete::RequestError)
    end

    it 'returns the response object' do
      expect(connection_double)
        .to receive(method)
        .and_return(api_response)

      response = subject.get
      expect(response.status).to eq 200
      expect(response.body).to eq "Search Results"
    end

    it 'raises a RequestError when the status == 404' do
      api_response = Faraday::Response.new(status: 404, body: "Error")
      expect(connection_double)
        .to receive(method)
        .and_return(api_response)

      expect{ subject.get }.to raise_error(PassClient::Athlete::RequestError)
    end

    it 'raises a RequestError when the status == 301' do
      api_response = Faraday::Response.new(status: 301, body: "Error")
      expect(connection_double)
        .to receive(method)
        .and_return(api_response)

      expect{ subject.get }.to raise_error(PassClient::Athlete::RequestError)
    end
  end
end
