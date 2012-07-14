require 'simplecov'
SimpleCov.start

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'yaml'
require 'rake'
require 'rspec'
require 'hashr'

SYS_ENV = 'test'
APP_CONFIG = YAML.load_file('./spec/config.yml')[SYS_ENV].deep_symbolize_keys

require './lib/dca'


# Set resque call perform method inline, without putting into redis queue
Resque.inline = true

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  
end
