source :gemcutter

gem 'sinatra', :require => 'sinatra/base', :git => 'git://github.com/sinatra/sinatra.git', :ref => 'def6fb5a34cbd5ab24fd'
gem 'haml'
gem "bson_ext"
gem "mongoid"

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
