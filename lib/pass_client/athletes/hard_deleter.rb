# frozen_string_literal: true

require "pass_client/athletes/shared"

module PassClient
  module Athlete
    class HardDeleter
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
        connection.delete(url: "/api/partner_athlete_search/v1/athlete/#{@id}",
                          params: { hard_delete: true },
                          headers: auth_header)
      end
    end
  end
end
