require 'pry'

require 'parsers/parser'
require 'parsers/default_parser'
require 'parsers/csv_parser'

require 'loggers/logger'
require 'loggers/default_logger'
require 'loggers/csv_logger'
require 'loggers/stdout_logger'

require 'processors/processor'
require 'processors/default_processor'

RSpec.configure do |config|
  config.color = true
end
