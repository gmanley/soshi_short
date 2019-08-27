module Setup
  @initializers = []

  def self.registered(app)
    setup(app)
  end

  def self.setup(app, except: [])
    @initializers.each do |initializer|
      if except.include?(initializer[:name])
        logger.info("Skipping initializer #{initializer[:name]}")
      else
        logger.info("Loading initializer #{initializer[:name]}")
        initializer[:block].call(app)
      end
    end
  end

  def self.root
    File.expand_path('../', __dir__)
  end

  def self.env
    ENV['RACK_ENV']
  end

  def self.logger
    return @logger if @logger

    @logger = Logger.new($stdout)
    @logger.level = Logger::FATAL if env == 'test'
    @logger
  end

  def self.initializer(name, &block)
    @initializers << { name: name, block: block }
  end

  initializer :active_record do |app|
    app.register Sinatra::ActiveRecordExtension
  end

  initializer :bugsnag do |app|
    app.enable :raise_errors

    Bugsnag.configure do |config|
      config.project_root = root
      config.release_stage = env
      config.notify_release_stages = ['production']
      config.send_environment = true
      config.api_key = ENV['BUGSNAG_API_KEY']
      config.logger = logger
    end
  end


  initializer :dotenv do
    existing_env_files = [
      ".env.#{env}.local",
      ('.env.local' unless env == 'test'),
      ".env.#{env}",
      '.env'
    ].compact.map { |p| File.join(root, p) if File.exist?(p) }.compact

    Dotenv.load!(*existing_env_files) if existing_env_files.any?
  end
end
