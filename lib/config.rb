require 'ostruct'

module Sinatra
  module Settings
    ENVIRONMENTS = %w(development production test)

    def config
      @config ||= config_file(File.join(APP_ROOT, 'config/config.yml'))
    end

    private
    def config_file(file)
      obj = config_for_env(YAML.load_file(file)) || {}
      obj.each { |key, value| obj[key] = config_for_env(value) }
      OpenStruct.new(obj)
    end

    def config_for_env(hash)
      if hash.respond_to? :keys and hash.keys.any? {|k| ENVIRONMENTS.include?(k)}
        non_env_specific = hash.reject {|k,v| ENVIRONMENTS.include?(k)}
        hash = hash[APP_ENV].merge(non_env_specific)
      end

      hash
    end
  end

  module Setup
    extend Settings

    def self.registered(app)
      setup_airbrake(app) if config.airbrake_api_key.present?
      setup_database(app)
      app.set :config, config
      app.register Sinatra::ActiveRecordExtension
    end

    private

    def self.setup_database(app)
      app.register Sinatra::ActiveRecordExtension
    end

    def self.setup_errors(app)
      app.enable :raise_errors
    end
  end
end
