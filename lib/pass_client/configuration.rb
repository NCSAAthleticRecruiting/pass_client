module PassClient
  class Configuration
    attr_reader :hostname, :port, :timeout, :open_timeout, :auth_id, :secret_key

    def initialize(opts = {})
      @timeout = opts[:timeout] || 1000
      @open_timeout = opts[:open_timeout] || 500
      @hostname = opts[:hostname] || "http://localhost"
      @auth_id = opts[:auth_id] || "auth_id"
      @secret_key = opts[:secret_key] || "secret_key"
      @port = opts[:port] || 443

      case ENV['RAILS_ENV']
      when "staging"
        @hostname = "http://data-staging.ncsasports.org"
      when "production"
        @hostname = "http://data.ncsasports.org"
      end
    end
  end
end
