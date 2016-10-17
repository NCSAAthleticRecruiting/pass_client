require 'pass_client/configuration'
RSpec.describe PassClient::Configuration do
  subject { described_class.new }
  before do
    ENV['PASS_CLIENT_ENV'] = nil
  end

  it 'attr_readers get set to default values' do
    expect(subject.auth_id).to eq "auth_id"
    expect(subject.secret_key).to eq "secret_key"
    expect(subject.hostname).to eq "http://localhost"
    expect(subject.timeout).to eq 1000
    expect(subject.open_timeout).to eq 500
    expect(subject.port).to be_nil
    expect(subject.sign_with).to eq :sha256
    expect(subject.token).to eq ""
  end

  it 'sets the hostname based on environment' do
    ENV['PASS_CLIENT_ENV'] = "staging"
    expect(subject.hostname). to eq "http://data-staging.ncsasports.org"
  end

  it 'sets the hostname based on environment' do
    ENV['PASS_CLIENT_ENV'] = "production"
    expect(subject.hostname). to eq "http://data.ncsasports.org"
  end

  it 'can override the default sign_with' do
    subject.sign_with = :sha512
    expect(subject.sign_with).to eq :sha512
  end

  it 'can override the default token' do
    subject.token = "a_valid_json_web_token"
    expect(subject.token).to eq "a_valid_json_web_token"
  end

  it 'can override default auth_id and secret_key' do
    subject.auth_id = "hello"
    subject.secret_key = "secret"
    expect(subject.auth_id).to eq "hello"
    expect(subject.secret_key).to eq "secret"
  end

  it 'takes an optional init hash to set all values' do
    ENV['PASS_CLIENT_ENV'] = "something"
    subject.timeout = "hello"
    subject.hostname = "secret"
    subject.port = 2222
    expect(subject.timeout).to eq "hello"
    expect(subject.hostname).to eq "secret"
    expect(subject.port).to eq 2222
  end

  it 'can set attributes' do
    subject.secret_key = "a new key"
    expect(subject.secret_key).to eq "a new key"
  end
end
