# frozen_string_literal: true

require "pass_client/athletes/shared"

module PassClient
  module Athlete
    class Getter
      include Athlete

      attr_reader :id

      def initialize(id:)
        @id = id
      end

      def get
        execute
      end

      def self.schema
        response = connection.get(url: "/api/partner_athlete_search/v1/athlete_schema")
        if response.status.between?(200, 299)
          response
        else
          error_handler(response, __method__)
        end
      end

      private

      def connect
        connection.get(url: "/api/partner_athlete_search/v1/athlete/#{id}", headers: auth_header)
      end

      class << self
        private

        def connection
          ::PassClient::Connection.unsigned_instance
        end
      end
    end
  end
end
