# frozen_string_literal: true
require "logger"

module PassClient
  class Env
    class << self
      def env
        determine_env
      end

      def logger
        @logger ||= defined? Rails ? ::Rails.logger : ::Logger.new(STDOUT)
      end

      private

      def determine_env
        env = ENV["PASS_CLIENT_ENV"] || ENV["RAILS_ENV"]

        env.nil? ? :development : env.downcase.to_sym
      end
    end
  end
end
