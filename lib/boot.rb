APP_ROOT = File.expand_path('../..', __FILE__)
APP_ENV = ENV['RACK_ENV'] ||= "development"

ENV['BUNDLE_GEMFILE'] = File.expand_path('../../Gemfile', __FILE__)
require 'bundler/setup'
Bundler.require(:default, APP_ENV)

require 'yaml'

Dir[File.join(APP_ROOT, "lib/**/*.rb")].each {|path| require path}
require File.join(APP_ROOT, 'app')

SoshiShort.setup_database