module SoshiShort
  class App < Sinatra::Base

    configure do
      set :config, YAML.load_file('config/config.yml')[environment.to_s]

      Mongoid.configure do |mongo_config|
        if ENV['MONGOHQ_URL'] # For heroku deploys
          conn = Mongo::Connection.from_uri(ENV['MONGOHQ_URL'])
          mongo_config.master = conn.db(URI.parse(ENV['MONGOHQ_URL']).path.gsub(/^\//, ''))
        else
          mongo_config.from_hash(config["database"])
        end
      end
      require "lib/url"
      require "lib/logger"

      register Sinatra::Logging
      log_requests
    end

    configure :production do
      unless config['hoptoad_api_key'].nil?
        enable :raise_errors
        use HoptoadNotifier::Rack
        HoptoadNotifier.configure do |hoptoad_config|
          hoptoad_config.api_key = config['hoptoad_api_key']
        end
      end
    end

    require 'lib/pagination_helper'
    helpers WillPaginate::ViewHelpers::Base
    helpers do
      def protected!
        unless authorized?
          response['WWW-Authenticate'] = %(Basic realm="Creating a new short link")
          throw(:halt, [401, "Not authorized\n"])
        end
      end

      def authorized?
        auth ||=  Rack::Auth::Basic::Request.new(request.env)
        auth.provided? && auth.basic? && auth.credentials && \
        auth.credentials == [
          settings.config['auth']['user'],
          settings.config['auth']['password']
        ]
      end

      def valid_key_provided?
        params['key'] == settings.config['auth']['key']
      end
    end

    get '/bookmark' do
      protected! unless valid_key_provided? || settings.environment != :production

      if valid_key_provided?
        url = Url.find_or_create_by(:full_url => params[:url])
        return url.short_url
      else
        @links = Url.paginate(:page => 1, :per_page => 100)
        haml :new
      end
    end

    get '/bookmark/:page_number' do |page_number|
      protected! unless settings.environment != :production

      @links = Url.paginate(:page => page_number, :per_page => 100)
      haml :new
    end

    get '/:url' do |url_key|
      url = Url.where(:url_key => url_key).first
      if url.nil?
        status 404
      else
        url.inc(:times_viewed, 1)
        url.last_accessed = Time.now
        url.save
        redirect url.full_url, 301
      end
    end

    not_found do
      redirect 'http://soshified.com/forums'
    end
  end
end
