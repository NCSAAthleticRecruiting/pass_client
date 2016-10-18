require 'pass_client/athletes/shared'

module PassClient
  module Athlete
    class Creator
      include Athlete

      attr_reader :body

      def initialize(body:)
        @body = body
      end

      def create!
        response = connection.post("/api/partner_athlete_search/v1/athlete/", request_body, auth_header)
        if response.status.between?(200, 299)
          response
        else
          error_handler(response, __method__)
        end
      end
    end
  end
end
