# frozen_string_literal: true

require "pass_client/athletes/shared"

module PassClient
  module Athlete
    class Search
      include Athlete

      attr_reader :search_terms

      def initialize(search_terms:)
        @search_terms = search_terms
      end

      def get
        execute
      end

      private

      def connect
        connection.get(url: "/api/partner_athlete_search/v1/search/athlete", params: search_terms, headers: auth_header)
      end
    end
  end
end
