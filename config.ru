require "bundler/setup"
Bundler.require(:default, (ENV['RACK_ENV'].to_sym || :development))
$:.unshift('.')

require 'app'
run SoshiShort::App
