# frozen_string_literal: true
require "pass_client/env"

RSpec.describe PassClient::Env do
  describe ".env" do
    before :all do
      @saved_env = ENV["PASS_CLIENT_ENV"]
    end

    after :all do
      ENV["PASS_CLIENT_ENV"] = @saved_env
    end

    context "when the ENV varaible is set" do
      let(:client_env) { described_class.send(:determine_env) }

      it "converts the value to a symbol" do
        ENV["PASS_CLIENT_ENV"] = "testing"

        expect(client_env).to eq(:testing)
      end

      it "converts the value to lowercase" do
        ENV["PASS_CLIENT_ENV"] = "TeStiNG"

        expect(client_env).to eq(:testing)
      end

      it "defaults to development" do
        ENV["PASS_CLIENT_ENV"], ENV["RAILS_ENV"] = nil

        expect(client_env).to eq(:development)
      end
    end
  end
end
