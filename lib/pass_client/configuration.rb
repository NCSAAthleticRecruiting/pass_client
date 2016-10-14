module PassClient
  class Configuration
    attr_accessor :hostname, :port, :timeout, :open_timeout, :auth_id, :secret_key

    def initialize
      @timeout = 1000
      @open_timeout = 500
      @auth_id = "auth_id"
      @secret_key = "secret_key"
      @port = 443

      case ENV['RAILS_ENV']
      when "staging"
        @hostname = "http://data-staging.ncsasports.org"
      when "production"
        @hostname = "http://data.ncsasports.org"
      else
        @hostname = "http://localhost"
      end
    end
  end
end
