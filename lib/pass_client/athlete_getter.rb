require 'pass_client/connection'
require 'pass_client/athlete_shared'

module PassClient
  class AthleteGetter
    include Athlete

    attr_reader :id

    def initialize(id:)
      @id = id
    end

    def get
      response = connection.get("/api/partner_athlete_search/v1/athlete/#{id}")
      if response.status.between?(200, 299)
        response
      else
        error_handler(response, __method__)
      end
    end

    def self.schema
      response = connection.get("/api/partner_athlete_search/v1/athlete_schema")
      if response.status.between?(200, 299)
        response
      else
        error_handler(response, __method__)
      end
    end

    private

    def self.connection
      Connection.unsigned_instance
    end
  end
end
