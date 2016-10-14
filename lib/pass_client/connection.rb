require 'faraday'
require 'ey-hmac/faraday'
require 'pass_client'

module PassClient
  ConnectionError = Class.new(StandardError)
  ResponseError = Class.new(StandardError)

  class Connection
    extend Forwardable

    attr_reader :hostname, :open_timeout, :timeout, :auth_id, :secret_key,:port

    def self.instance
      if @test_instance.nil?
        self.new(PassClient::Env.env)
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

    def initialize(env, rack_app: nil)
      config = ::PassClient.configuration

      @hostname = config.hostname
      @timeout  = config.timeout
      @open_timeout  = config.open_timeout
      @auth_id  = config.auth_id
      @secret_key  = config.secret_key
      @port = config.port

      # This allows stubbing out the server rack application
      # to allow testing for end to end testing of authentication
      # and our API.
      if env == :test && !rack_app.nil?
        @rack_app = rack_app
      end
    end

    def connection
      @connection ||= Faraday.new(base_uri, ssl: {verify: false}) do |c|
        c.response :logger unless PassClient::Env.env == :test

        c.use :hmac, auth_id, secret_key, sign_with: :sha256#, :sha512
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
      define_method(verb) do |url, params = nil, headers = nil, &block|
        unwrapped_repsonse = connection.send(verb, url, params, headers) do |r|
          r.options.timeout = timeout
          r.options.open_timeout = open_timeout

          r.headers['Content-Type'] = 'application/json'

          block.call(r) if block
        end

        Response.new unwrapped_repsonse
      end
    end

    [:put, :post, :patch].each do |verb|
      define_method(verb) do |url, body = nil, headers = nil, &block|
        unwrapped_response = connection.send(verb, url, body, headers) do |r|
          r.options.timeout = timeout
          r.options.open_timeout = open_timeout

          r.headers['Content-Type'] = 'application/json'

          block.call(r) if block
        end

        Response.new unwrapped_response
      end
    end
  end

  class Response < SimpleDelegator
    def initialize(faraday_response)
      super
      check_response_code(faraday_response.status)
    end

    private

    def check_response_code(response_code)
      if response_code < 200 || response_code >= 300
        raise ResponseError, "#{response_code} code for request, response: #{self}"
      else
        response_code
      end
    end
  end
end