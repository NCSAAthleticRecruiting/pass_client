require 'pass_client/athlete_shared'

module PassClient
  class AthleteDeleter
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
