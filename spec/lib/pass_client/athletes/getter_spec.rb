# frozen_string_literal: true

require "pass_client/athletes/getter"

RSpec.describe PassClient::Athlete::Getter do
  subject { described_class.new(id: id) }

  let(:token_manager_double) { instance_double(PassClient::TokenManager) }
  let(:connection_double) { instance_double(PassClient::Connection) }
  let(:id) { "123-abc-456" }
  let(:api_response) { Faraday::Response.new(status: 200, body: "") }
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

  it "sends a request to the correct address" do
    expect(connection_double)
      .to receive(method).with(url: "/api/partner_athlete_search/v1/athlete/#{id}", headers: { authorization: token })

    subject.get
  end

  it "gets the athlete_schema" do
    expect(connection_double)
      .to receive(method).with(url: "/api/partner_athlete_search/v1/athlete_schema")

    described_class.schema
  end

  context "with api responses" do
    let(:api_response) { Faraday::Response.new(status: 200, body: response_body) }
    let(:response_body) do
      { "data" =>
        { "id" => id, "attributes" => "All Athlete Data", "type" => "Athlete" } }.to_json
    end

    it "renew the jwt ONCE when the status == 401" do
      ::PassClient.configuration.token = token
      api_response = Faraday::Response.new(status: 401, body: "Error")
      expect(connection_double)
        .to receive(method)
        .and_return(api_response)
        .exactly(2).times

      allow(subject).to receive(:token).and_return(token)
      expect { subject.get }.to_not raise_error
    end

    it "returns the response object" do
      expect(connection_double)
        .to receive(method)
        .and_return(api_response)

      response = subject.get
      expect(response.status).to eq 200
      expect(response.body).to eq response_body
    end

    it "raises no exceptions when the status == 404" do
      response_404 = Faraday::Response.new(status: 404, body: "Error")
      allow(connection_double)
        .to receive(method)
        .and_return(response_404)
      subject = described_class.new(id: id)

      expect { subject.get }.to_not raise_error
      response = subject.get
      expect(response.status).to eq 404
    end
  end
end
