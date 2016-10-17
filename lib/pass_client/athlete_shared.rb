require 'json'

module PassClient
  module Athlete
    RequestError = Class.new(StandardError)

    private

    def connection
      Connection.unsigned_instance
    end

    def convert_body
      update_body.kind_of?(Hash) ? update_body.to_json : update_body
    end

    def error_handler(response, method=nil)
      raise RequestError, "Response code invalid #{response.status}: method: #{method}\nResponse body: #{response.body}"
    end
  end
end
