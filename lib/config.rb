require 'ostruct'

module SoshiShort
  class Settings

    ENVIRONMENTS = %w(development production test)

    def self.config_file(file)
      obj = config_for_env(YAML.load_file(file)) || {}
      obj.each { |key, value| obj[key] = config_for_env(value) }
      OpenStruct.new(obj)
    end

    def self.config_for_env(hash)
      if hash.respond_to? :keys and hash.keys.any? {|k| ENVIRONMENTS.include?(k)}
        non_env_specific = hash.reject {|k,v| ENVIRONMENTS.include?(k)}
        hash = hash[ENV['RACK_ENV']].merge(non_env_specific)
      end
      hash
    end
  end

  class << self
    def config
      @config ||= Settings.config_file('config/config.yml')
    end

    def setup_database
      Mongoid.configure do |mongoid_config|
        if ENV['MONGOHQ_URL'] # For heroku deploys
          conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
          mongoid_config.master = conn.db(URI.parse(ENV['MONGOHQ_URL']).path.gsub(/^\//, ''))
        else
          mongoid_config.from_hash(config.database)
        end
      end
    end
  end
end
