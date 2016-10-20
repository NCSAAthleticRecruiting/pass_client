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

    def auth_header
      { authorization: token }
    end

    def execute
      response = connect
      if response.status == 401
        retry_connection
      else
        response_handler(response)
      end
    end

    def retry_connection
      renew_token
      response = connect
      response_handler(response)
    end

    def response_handler(response)
      if response.status.between?(200, 299)
        response
      else
        error_handler(response, __method__)
      end
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
