# frozen_string_literal: true
require "pass_client/athletes/deleter"

RSpec.describe PassClient::Athlete::Deleter do
  subject { described_class.new(id: id) }

  let(:token_manager_double) { instance_double(PassClient::TokenManager) }
  let(:connection_double) { instance_double(PassClient::Connection) }
  let(:id) { "123-abc-456" }
  let(:api_response) { Faraday::Response.new(status: 200, body: "") }
  let(:method) { :delete }
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

    subject.delete!
  end

  it "renew the jwt ONCE when the status == 401" do
    ::PassClient.configuration.token = token
    api_response = Faraday::Response.new(status: 401, body: "Error")
    expect(connection_double)
      .to receive(method)
      .and_return(api_response)
      .exactly(2).times

    allow(subject).to receive(:token).and_return(token)
    expect { subject.delete! }.to_not raise_error
  end
end
