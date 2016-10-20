require 'pass_client/representers/token'

module PassClient
  class TokenManager
    AuthorizationError = Class.new(StandardError)

    def token!
      return config.token unless config.token == ""
      response = connect
      renew! if response.status == 401
      set_token(response.body)
    end

    def renew!
      response = connect
      error_handler(response, __method__) if response.status == 401
      set_token(response.body)
    end

    private

    def connect
      connection.post(url: "/api/partner_athlete_search/v1/issue_token/", body: {auth_id: config.auth_id}.to_json)
    end

    def set_token(body)
      token = deserialize_body(body)
      config.token = token.jwt
    end

    def deserialize_body(body)
      ::PassClient::Representer::Token.new(body)
    end

    def connection
      ::PassClient::Connection.instance
    end

    def config
      ::PassClient.configuration
    end

    def error_handler(response, method=nil)
      raise AuthorizationError, "Response code invalid #{response.status}: method: #{method}\nResponse body: #{response.body}"
    end

  end
end
