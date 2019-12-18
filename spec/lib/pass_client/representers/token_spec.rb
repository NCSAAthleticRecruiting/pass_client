# frozen_string_literal: true
require "pass_client/representers/token"
require "json"

RSpec.describe PassClient::Representer::Token do
  subject { described_class.new(json) }
  let(:json) do
    { "data" =>
      { "id" => "auth_id",
        "attributes" => { "token" => "secret_json_web_token" },
        "type" => "JSON Web Token" } }.to_json
  end

  it "converts the json to a Struct" do
    expect(subject.token.id).to eq "auth_id"
    expect(subject.token.type).to eq "JSON Web Token"
    expect(subject.jwt).to eq "secret_json_web_token"
  end

  it "sets the status attribute" do
    expect(subject.status).to eq :valid
  end

  it "converts an error message" do
    errors = { errors: [
      {
        message: "something went wrong",
        detail: "somethig is here too.",
      },
    ] }.to_json
    subject = described_class.new(errors)
    expect(subject.token.message).to eq "something went wrong"
    expect(subject.token.detail).to eq "somethig is here too."
    expect(subject.status).to eq :error
  end

  it "returns a hash if it cannot deserialize" do
    default = { "test" => "not a match" }
    subject = described_class.new(default.to_json)
    expect(subject.token.message).to eq "Could not deserialize the body"
    expect(subject.token.detail).to eq default
    expect(subject.status).to eq :error
    expect(subject.jwt).to be_nil
  end
end
