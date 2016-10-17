require 'pass_client/connection'
require 'pass_client/athlete_shared'

module PassClient
  class AthleteCreator
    include Athlete

    attr_reader :update_body

    def initialize(update_body:)
      @update_body = update_body
    end

    def create!
      response = connection.post("/api/partner_athlete_search/v1/athlete/", {athlete: convert_body})
      if response.status.between?(200, 299)
        response
      else
        error_handler(response, __method__)
      end
    end
  end
end
