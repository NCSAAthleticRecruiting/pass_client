# frozen_string_literal: true

require "pass_client/athletes/shared"

module PassClient
  module Athlete
    class Deleter
      include Athlete

      attr_reader :id

      def initialize(id:)
        @id = id
      end

      def delete!
        execute
      end

      private

      def connect
        connection.delete(url: "/api/partner_athlete_search/v1/athlete/#{id}", headers: auth_header)
      end
    end
  end
end
