module PassClient
  module Athlete
    RequestError = Class.new(StandardError)

    private

    def connection
      ::PassClient::Connection.unsigned_instance
    end

    def request_body
      { athlete: body }.to_json
    end

    def error_handler(response, method=nil)
      if PassClient::Env.env != :test
        PassClient::Env.logger.warn "RequestError method: #{method}"
        PassClient::Env.logger.warn response.inspect
      end
      raise RequestError, "Response code invalid #{response.status}: method: #{method}\nResponse body: #{response.body}, Response: #{response.inspect}"
    end

    def token
      ::PassClient::TokenManager.new.token!
    end

    def auth_header
      { authorization: token }
    end
  end
end
