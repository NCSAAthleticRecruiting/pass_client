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
        response = connection.delete("/api/partner_athlete_search/v1/athlete/#{id}", nil, auth_header)
        if response.status.between?(200, 299)
          response
        else
          error_handler(response, __method__)
        end
      end
    end
  end
end
