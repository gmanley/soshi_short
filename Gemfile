source :gemcutter

gem 'sinatra', :require => 'sinatra/base', :git => 'git://github.com/sinatra/sinatra.git'
gem 'haml'
gem 'bson_ext'
gem 'will_paginate_mongoid', :git => 'git://github.com/gmanley/will_paginate_mongoid.git'
gem 'rack-test', :require => false
gem 'thin'

group :development do
  gem 'thin'
  gem 'sinatra-contrib', :git => 'git://github.com/gmanley/sinatra-contrib.git', :require => 'sinatra/reloader'
  gem 'pry', :git => 'git://github.com/pry/pry.git'
end

group :production do
  gem 'airbrake'
end
