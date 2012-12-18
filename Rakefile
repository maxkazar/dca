# encoding: utf-8

require 'rubygems'
require 'bundler'

begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "dca"
  gem.homepage = "http://github.com/maxkazar/dca"
  gem.license = "MIT"
  gem.summary = %Q{DCA}
  gem.description = %Q{DCA}
  gem.email = "maxkazargm@gmail.com"
  gem.authors = ["Maxim Kazarin"]
  # dependencies defined in Gemfile
end
Jeweler::RubygemsDotOrgTasks.new

require 'yard'
YARD::Rake::YardocTask.new

SYS_ENV = 'development' unless defined? ENV['SYS_ENV']

require './lib/dca'
require 'resque/tasks'
require './spec/mock/analyzer_job' if SYS_ENV == 'test'
