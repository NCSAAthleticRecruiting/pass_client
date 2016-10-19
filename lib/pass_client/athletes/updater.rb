require 'pass_client/athletes/shared'

module PassClient
  module Athlete
    class Updater
      include Athlete

      attr_reader :id, :body

      def initialize(id:, body:)
        @id = id
        @body = body
      end

      def update!
        execute
      end

      private

      def connect
        connection.put("/api/partner_athlete_search/v1/athlete/#{id}", request_body, auth_header)
      end
    end
  end
end
