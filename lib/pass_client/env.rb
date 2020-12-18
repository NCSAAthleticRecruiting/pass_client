# frozen_string_literal: true

require "logger"

module PassClient
  class Env
    def self.env
      determine_env
    end

    def self.logger
      @logger ||= defined? Rails ? ::Rails.logger : ::Logger.new(STDOUT)
    end

    class << self
      private

      def determine_env
        env = ENV["PASS_CLIENT_ENV"] || ENV["RAILS_ENV"]

        env.nil? ? :development : env.downcase.to_sym
      end
    end
  end
end
