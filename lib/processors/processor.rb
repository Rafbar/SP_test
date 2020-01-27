module Processors
  class Processor
    OUTPUT_FORMAT_MAP = {
      'log' => ::Loggers::DefaultLogger,
      'csv' => ::Loggers::CsvLogger
    }.freeze

    INPUT_FORMAT_MAP = {
      'log' => ::Parsers::DefaultParser,
      'csv' => ::Parsers::CsvParser
    }.freeze

    def initialize(options)
      @options = options
    end

    [:input, :output].each do |method_name|
      define_method method_name do
        @options[method_name]
      end
    end

    def output?
      !!@options[:output]
    end

    def silent?
      @options[:silent]
    end

    def fail_fast?
      @options[:fail_fast]
    end

    def stoud_logger
      @stoud_logger ||= ::Loggers::StdoutLogger.new unless silent?
    end

    def output_logger
      @output_logger ||= OUTPUT_FORMAT_MAP[@options[:output_format]].new(file_name: output) if output?
    end

    def input_parser
      @input_parser ||= INPUT_FORMAT_MAP[@options[:input_format]].new(input: input, fail_fast: fail_fast?)
    end
  end
end
