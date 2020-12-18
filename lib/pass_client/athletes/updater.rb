# frozen_string_literal: true

require "pass_client/athletes/shared"

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
        connection.put(url: "/api/partner_athlete_search/v1/athlete/#{id}", body: request_body, headers: auth_header)
      end
    end
  end
end
