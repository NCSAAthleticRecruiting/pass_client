# frozen_string_literal: true
require "faraday"
require "ey-hmac/faraday"

module PassClient
  ConnectionError = Class.new(StandardError)
  ResponseError = Class.new(StandardError)

  class Connection
    extend Forwardable

    attr_reader :hostname, :open_timeout, :timeout, :auth_id, :secret_key, :port, :sign_with, :signed

    def self.instance
      if ::PassClient.configuration.auth_id == "CHANGE_ME" || PassClient.configuration.secret_key == "CHANGE_ME"
        raise ConnectionError, "You are using default values for the auth_id or secret_key.\n" \
          "These values are unlikely to allow you to authenticate properly.\nSee README.md " \
          "for instructions on configuring the gem."
      end
      if @test_instance.nil?
        new(PassClient::Env.env)
      else
        @test_instance
      end
    end

    def self.unsigned_instance
      if @test_instance.nil?
        new(PassClient::Env.env, signed: false)
      else
        @test_instance
      end
    end

    def self.set_test_instance(instance)
      @test_instance = instance
    end

    def self.clear_test_instance
      @test_instance = nil
    end

    def initialize(env, rack_app: nil, signed: true)
      config = ::PassClient.configuration

      @hostname = config.hostname
      @timeout  = config.timeout
      @open_timeout = config.open_timeout
      @auth_id = config.auth_id
      @secret_key = config.secret_key
      @port = config.port
      @sign_with = config.sign_with
      @signed = signed
      @silent = config.silent

      # This allows stubbing out the server rack application
      # to allow testing for end to end testing of authentication
      # and our API.
      if env == :test && !rack_app.nil?
        @rack_app = rack_app
      end
    end

    def connection
      @connection ||= Faraday.new(base_uri, ssl: { verify: false }) do |c|
        c.response :logger unless @silent
        if signed
          c.use :hmac, auth_id, secret_key, sign_with: sign_with
        end
        # In the test env we short circuit the HTTP request and allow for a rack application
        # to be given upon creation of the connection.  This allows for end to end testing
        # of the client.
        @rack_app.nil? ? c.adapter(Faraday.default_adapter) : c.adapter(:rack, @rack_app)
      end
    end

    def base_uri
      URI.parse(@hostname)
    end

    [:get, :delete, :head].each do |verb|
      define_method(verb) do |url:, params: nil, headers: nil, &block|
        unwrapped_repsonse = connection.send(verb, url, params, headers) do |r|
          r.options.timeout = timeout
          r.options.open_timeout = open_timeout
          r.headers["Content-Type"] = "application/json"

          block&.call(r)
        end

        Response.new unwrapped_repsonse
      end
    end

    [:put, :post, :patch].each do |verb|
      define_method(verb) do |url:, body: nil, headers: nil, &block|
        unwrapped_response = connection.send(verb, url, body, headers) do |r|
          r.options.timeout = timeout
          r.options.open_timeout = open_timeout
          r.headers["Content-Type"] = "application/json"

          block&.call(r)
        end

        Response.new unwrapped_response
      end
    end
  end

  class Response < SimpleDelegator
    def initialize(faraday_response)
      super
    end
  end
end
