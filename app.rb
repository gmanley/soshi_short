class App < Sinatra::Base
  register Setup

  configure(:development) do |c|
    register(Sinatra::Reloader)
    c.also_reload('lib/*.rb')
  end

  configure do
    set(:root, APP_ROOT)
    register Sinatra::Pagination
  end

  helpers do
    def protected!
      unless authorized? || valid_key_provided?
        response['WWW-Authenticate'] = %(Basic realm="Managing urls")
        throw(:halt, [401, "Not authorized\n"])
      end
    end

    def authorized?
      auth ||=  Rack::Auth::Basic::Request.new(request.env)
      auth.provided? && auth.basic? && auth.credentials && \
      auth.credentials == [
        ENV['ADMIN_USER'],
        ENV['ADMIN_PASSWORD']
      ]
    end

    def valid_key_provided?
      if auth = ENV['API_KEY']
        params['key'] == auth['key']
      end
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
    if url = Url.find_by(url_key: url_key)
      Url.increment_counter(:times_viewed, url.id)
      url.update!(last_accessed: Time.now)

      redirect(url.full_url, 301)
    else
      status 404
    end
  end

  not_found do
    redirect(ENV['REDIRECT_URL'])
  end
end
