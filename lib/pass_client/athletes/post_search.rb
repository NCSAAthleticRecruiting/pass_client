# frozen_string_literal: true

require "pass_client/athletes/shared"

module PassClient
  module Athlete
    class PostSearch
      include Athlete

      attr_reader :search_terms

      def initialize(search_terms:)
        @search_terms = search_terms
      end

      def post
        execute
      end

      private

      def connect
        connection.post(
          url: "/api/partner_athlete_search/v1/search/athlete",
          body: search_terms.to_json,
          headers: auth_header
        )
      end
    end
  end
end
