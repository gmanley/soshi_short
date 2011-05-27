source :gemcutter

gem 'sinatra', :require => 'sinatra/base', :git => 'git://github.com/sinatra/sinatra.git'
gem 'haml'
gem "bson_ext"
gem 'mongoid', :git => 'git://github.com/gmanley/mongoid.git', :branch => 'pagination'

group :development do
  gem 'shotgun', :require => false
  gem 'thin', :require => false
  gem 'capistrano', :require => false
  gem 'heroku', :require => false
end

group :test do
  gem 'rack-test', :require => 'rack/test'
  gem 'timecop'
end
