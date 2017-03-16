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

    def auth_header
      { authorization: token }
    end

    def execute
      response = connect
      if response.status == 401
        retry_connection
      else
        response
      end
    end

    def retry_connection
      renew_token
      response = connect
      response
    end

    def renew_token
      token_manager.renew!
    end

    def token
      token_manager.token!
    end

    def token_manager
      ::PassClient::TokenManager.new
    end
  end
end
