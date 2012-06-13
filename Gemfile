source :rubygems

gem 'sinatra', :require => 'sinatra/base', :git => 'git://github.com/sinatra/sinatra.git'
gem 'haml'
gem 'bson_ext'
gem 'will_paginate_mongoid'
gem 'rack-test', :require => false
gem 'thin'

group :development do
  gem 'thin'
  gem 'sinatra-contrib', :git => 'git://github.com/sinatra/sinatra-contrib.git', :require => 'sinatra/reloader'
  gem 'pry', :git => 'git://github.com/pry/pry.git'
end

group :production do
  gem 'airbrake'
end
