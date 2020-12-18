# frozen_string_literal: true

require "pass_client/env"

module PassClient
  class Configuration
    attr_accessor :hostname, :port, :timeout, :open_timeout, :auth_id, :secret_key, :sign_with, :token, :silent

    def initialize
      @timeout = 1000
      @open_timeout = 500
      @auth_id = "CHANGE_ME"
      @secret_key = "CHANGE_ME"
      @sign_with = :sha256
      @token = ""
      @silent = true

      @hostname = case PassClient::Env.env
                  when :staging
                    "http://data-staging.ncsasports.org"
                  when :production
                    "http://data.ncsasports.org"
                  else
                    "http://localhost"
      end
    end
  end
end
