require 'pass_client/configuration'
RSpec.describe PassClient::Configuration do
  subject { described_class.new }

  it 'attr_readers get set to default values' do
    expect(subject.auth_id).to eq "auth_id"
    expect(subject.secret_key).to eq "secret_key"
    expect(subject.hostname).to eq "http://localhost"
    expect(subject.timeout).to eq 1000
    expect(subject.open_timeout).to eq 500
    expect(subject.port).to eq 443
  end

  it 'sets the hostname based on environment' do
    ENV['RAILS_ENV'] = "staging"
    expect(subject.hostname). to eq "http://data-staging.ncsasports.org"
  end

  it 'sets the hostname based on environment' do
    ENV['RAILS_ENV'] = "production"
    expect(subject.hostname). to eq "http://data.ncsasports.org"
  end

  it 'can override default auth_id and secret_key' do
    subject = described_class.new
    subject.auth_id = "hello"
    subject.secret_key = "secret"
    expect(subject.auth_id).to eq "hello"
    expect(subject.secret_key).to eq "secret"
  end

  it 'takes an optional init hash to set all values' do
    ENV['RAILS_ENV'] = "something"
    subject = described_class.new
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
