require 'pass_client/athlete_deleter'

RSpec.describe PassClient::AthleteDeleter do
  subject { described_class.new(id: id) }
  let(:connection_double) { instance_double(PassClient::Connection) }
  let(:id) { "123-abc-456" }
  let(:api_response) { Faraday::Response.new(status: 200, body: "") }
  let(:method) { :delete }

  before do
    allow(PassClient::Connection)
      .to receive(:instance)
      .and_return(connection_double)
    allow(connection_double)
      .to receive(method)
      .and_return(api_response)
  end

  it 'sends a request to the correct address' do
    expect(connection_double)
      .to receive(method).with("/api/partner_athlete_search/v1/athlete/#{id}")

    subject.delete!
  end
end
