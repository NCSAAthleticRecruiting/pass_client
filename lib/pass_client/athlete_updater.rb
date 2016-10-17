require 'pass_client/connection'
require 'pass_client/athlete_shared'
require 'JSON'

module PassClient
  class AthleteUpdater
    include Athlete

    attr_reader :id, :update_body

    def initialize(id:, update_body:)
      @id = id
      @update_body = update_body
    end

    def update!
      response = connection.put("/api/partner_athlete_search/v1/athlete/#{id}", {athlete: convert_body})
      if response.status.between?(200, 299)
        response
      else
        error_handler(response, __method__)
      end
    end
  end
end
