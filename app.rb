class App < Sinatra::Base
  register Sinatra::Setup

  configure(:development) do |c|
    register(Sinatra::Reloader)
    c.also_reload('lib/*.rb')
  end

  configure do
    set(:root, APP_ROOT)
    set(:haml, { format: :html5 })

    enable(:sessions)
    set(:session_secret, config.session_secret)

    register Sinatra::Pagination
  end

  helpers do
    def protected!
      unless authorized? or valid_key_provided? or settings.environment != :production
        response['WWW-Authenticate'] = %(Basic realm="Managing urls")
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
    protected!

    if valid_key_provided?
      url = Url.find_or_create_by(full_url: params[:url])
      url.short_url
    else
      @links = Url.paginate(page: 1, per_page: 100)
      haml :new
    end
  end

  get '/bookmark/:page_number' do |page_number|
    protected!

    @links = Url.paginate(page: page_number, per_page: 100)
    haml :new
  end

  get '/:url' do |url_key|
    if url = Url.where(url_key: url_key).first
      url.inc(:times_viewed, 1)
      url.last_accessed = Time.now
      url.save
      redirect(url.full_url, 301)
    else
      status 404
    end
  end

  not_found do
    redirect(settings.config.redirect_url)
  end
end