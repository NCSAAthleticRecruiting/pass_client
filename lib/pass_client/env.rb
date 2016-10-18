require 'logger'

module PassClient
  class Env

    def self.env
      self.determine_env
    end

    def self.logger
      @logger ||= (defined? Rails) ? ::Rails.logger : ::Logger.new(STDOUT)
    end

    private

    def self.determine_env
      env = ENV['PASS_CLIENT_ENV'] || ENV['RAILS_ENV']

      env.nil? ? :development : env.downcase.to_sym
    end
  end
end
