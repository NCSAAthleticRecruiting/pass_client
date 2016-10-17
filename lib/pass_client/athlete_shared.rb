require 'pass_client/token_manager'

module PassClient
  module Athlete
    RequestError = Class.new(StandardError)

    private

    def connection
      Connection.unsigned_instance
    end

    def request_body
      { athlete: body }.to_json
    end

    def error_handler(response, method=nil)
      raise RequestError, "Response code invalid #{response.status}: method: #{method}\nResponse body: #{response.body}"
    end

    def token
      ::PassClient::TokenManager.new.token!
    end

    def auth_header
      { authorization: token }#.to_json
    end
  end
end
