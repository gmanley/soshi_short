source "https://rubygems.org"

ruby '2.6.3'

gem 'sinatra', require: 'sinatra/base', git: 'git://github.com/sinatra/sinatra.git'

gem 'activerecord', '~> 6.1'
gem 'sinatra-activerecord'
gem 'pg'
gem 'will_paginate'

gem 'bugsnag', '~> 6.11'
gem 'dotenv', '~> 2.7'

gem 'haml'
gem 'rake'
gem 'rack-test', require: false
gem 'thin'
gem 'pry', git: 'git://github.com/pry/pry.git'

group :development do
  gem 'sinatra-contrib', require: 'sinatra/reloader'
end

group :test do
  gem 'database_cleaner'
  gem 'rspec'
  gem 'faker'
end
