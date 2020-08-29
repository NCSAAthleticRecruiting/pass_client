# frozen_string_literal: true
require "pass_client/athletes/shared"

module PassClient
  module Athlete
    class Creator
      include Athlete

      attr_reader :body

      def initialize(body:)
        @body = body
      end

      def create!
        execute
      end

      private

      def connect
        connection.post(url: "/api/partner_athlete_search/v1/athlete/", body: request_body, headers: auth_header)
      end
    end
  end
end
