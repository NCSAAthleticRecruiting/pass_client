require 'pass_client/athletes/shared'

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
        connection.delete("/api/partner_athlete_search/v1/athlete/#{id}", nil, auth_header)
      end
    end
  end
end
