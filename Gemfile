source :rubygems

gem 'sinatra', require: 'sinatra/base', git: 'git://github.com/sinatra/sinatra.git'

gem 'mongoid', '~> 2.4'
gem 'bson_ext'
gem 'will_paginate_mongoid'

gem 'haml'
gem 'rake'
gem 'rack-test', require: false
gem 'thin'
gem 'pry', git: 'git://github.com/pry/pry.git'

group :development do
  gem 'heroku'
  gem 'sinatra-contrib', git: 'git://github.com/gmanley/sinatra-contrib.git', require: 'sinatra/reloader'
end

group :production do
  gem 'airbrake'
end

group :test do
  gem 'database_cleaner'
  gem 'rspec'
  gem 'faker'
end