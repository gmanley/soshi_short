module SoshiShort
  class App < Sinatra::Base

    configure(:development) do |c|
      register Sinatra::Reloader
      c.also_reload('lib/*.rb')
    end

    configure(:production) do
      set :haml, {ugly: true}

      enable :raise_errors
      disable :logging
      use Airbrake::Rack
      Airbrake.configure do |airbrake_config|
        airbrake_config.api_key = config.airbrake_api_key
      end
    end

    configure do
      set :root, APP_ROOT
      set :config, SoshiShort.config
      register Sinatra::Pagination
    end

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
          settings.config.auth['user'],
          settings.config.auth['password']
        ]
      end

      def valid_key_provided?
        params['key'] == settings.config.auth['key']
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
      redirect settings.config.redirect_url
    end
  end
end
