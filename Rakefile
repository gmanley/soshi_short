require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = %w[-c -fprogress -r./spec/spec_helper.rb]
  t.pattern    = 'spec/**/*_spec.rb'
end

require File.expand_path('../lib/boot', __FILE__)
require 'sinatra/activerecord/rake'
ENV['RACK_ENV'] ||= 'development'
