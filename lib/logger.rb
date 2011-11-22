module Sinatra
  module Logging
    module Helpers
      def logger
        self.class.logger
      end
    end

    @@logger = nil
    def logger
      ENV['LOG_SHIFT_AGE'] ||= '10'
      unless @@logger
        @@logger = Logger.new(File.join(File.dirname(__FILE__), "..", "log", "#{settings.environment}.log"), ENV['LOG_SHIFT_AGE'].to_i, ENV['LOG_SHIFT_SIZE'] ? ENV['LOG_SHIFT_SIZE'].to_i : nil)
        @@logger.level = Logger.const_get(ENV['LOG_LEVEL']) if ENV['LOG_LEVEL']
        @@logger.formatter = proc {|severity, datetime, progname, msg| "[#{datetime}] #{severity}  #{msg}\n"}
      end
      @@logger
    end

    def log_requests
      before { logger.info("#{request.request_method} #{request.path}") }
    end

    def self.registered(app)
      app.helpers Sinatra::Logging::Helpers
    end
  end

  register Logging
end