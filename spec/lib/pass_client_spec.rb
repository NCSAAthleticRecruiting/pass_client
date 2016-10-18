require 'pass_client/pass_client'
require 'pass_client/connection'

RSpec.describe PassClient do
  it 'has a version number' do
    expect(PassClient::VERSION).not_to be nil
    expect(PassClient::VERSION.kind_of?(String)).to be_truthy
  end

  it 'sets default configuration values' do
    PassClient.reset
    expect(PassClient.configuration.auth_id).to eq "CHANGE_ME"
    expect(PassClient.configuration.timeout).to eq 1000
  end

  it 'resets the configuration' do
    PassClient.configure do |config|
      config.auth_id = "test_auth_id"
    end
    expect(PassClient.configuration.auth_id).to eq "test_auth_id"

    PassClient.reset
    expect(PassClient.configuration.auth_id).to eq "CHANGE_ME"
  end

  it 'take a configuration block' do
    PassClient.configure do |config|
      config.auth_id = "test_auth_id"
    end

    expect(PassClient.configuration.auth_id).to eq "test_auth_id"
  end
end
