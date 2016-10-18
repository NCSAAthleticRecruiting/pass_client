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
        response = connection.put("/api/partner_athlete_search/v1/athlete/#{id}", request_body, auth_header)
        if response.status.between?(200, 299)
          response
        else
          error_handler(response, __method__)
        end
      end
    end
  end
end