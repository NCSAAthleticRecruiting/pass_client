# frozen_string_literal: true
module PassClient
  module Representer
    class Token
      attr_reader :body, :token, :jwt
      attr_accessor :status

      TokenRepresenter = Struct.new(:id, :attributes, :type, :token)
      ErrorRepresenter = Struct.new(:message, :detail, :token)

      def initialize(json)
        @body = parse_body(json)
        @status = nil
        @token = structify
        @jwt = @token.token
      end

      private

      def parse_body(json)
        json.is_a?(String) ? JSON.parse(json) : json
      end

      def structify
        if body.key?("data")
          @status = :valid
          TokenRepresenter.new(
            body["data"]["id"],
            body["data"]["attributes"],
            body["data"]["type"],
            body["data"]["attributes"]["token"]
          )
        elsif body.key?("errors")
          @status = :error
          error = body["errors"].first
          ErrorRepresenter.new(
            error["message"],
            error["detail"]
          )
        else
          @status = :error
          ErrorRepresenter.new(
            "Could not deserialize the body",
            body
          )
        end
      end
    end
  end
end
