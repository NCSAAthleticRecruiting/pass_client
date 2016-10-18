require 'pass_client/athletes/deleter'

RSpec.describe PassClient::Athlete::Deleter do
  subject { described_class.new(id: id) }
  let(:connection_double) { instance_double(PassClient::Connection) }
  let(:id) { "123-abc-456" }
  let(:api_response) { Faraday::Response.new(status: 200, body: "") }
  let(:method) { :delete }
  let(:token) { "atoken" }

  before do
    allow(PassClient::Connection)
      .to receive(:unsigned_instance)
      .and_return(connection_double)
    allow(connection_double)
      .to receive(method)
      .and_return(api_response)
  end

  it 'sends a request to the correct address' do
    expect(connection_double)
      .to receive(method).with("/api/partner_athlete_search/v1/athlete/#{id}", nil, {authorization: token})

    subject.delete!
  end
end
