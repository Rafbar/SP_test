require 'rubygems'
require 'bundler/setup'

require './lib/parsers/parser'
require './lib/parsers/default_parser'
require './lib/parsers/csv_parser'

require './lib/loggers/logger'
require './lib/loggers/default_logger'
require './lib/loggers/csv_logger'
require './lib/loggers/stdout_logger'

require './lib/processors/processor'
require './lib/processors/default_processor'

# Core
require 'micro-optparse'

# Test
require 'rspec'

# Dev
require 'pry'

options = Parser.new do |p|
   p.banner = "SmartPension page views parser"
   p.version = "1.0"
   p.option :input, "input file name", default: "webserver.log"
   p.option :input_format, "input file format", default: "log", value_in_set: ['log', 'csv']
   p.option :output, "optional output file (instead of STDOUT)"
   p.option :output_format, "output file format", default: "log", value_in_set: ['log', 'csv']
   p.option :processor, "select processor", default: "Processors::DefaultProcessor", value_in_set: ['Processors::DefaultProcessor']
   p.option :silent, "do not log into STDOUT"
   p.option :fail_fast, "exit at first input error?"
end.process!

Object.const_get(options[:processor]).new(options).run
