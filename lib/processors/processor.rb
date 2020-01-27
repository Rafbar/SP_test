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
      @processor_result = {}
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

    def stdout_logger
      @stdout_logger ||= ::Loggers::StdoutLogger.new unless silent?
    end

    def output_logger
      @output_logger ||= OUTPUT_FORMAT_MAP[@options[:output_format]].new(file_name: output) if output?
    end

    def input_parser
      @input_parser ||= INPUT_FORMAT_MAP[@options[:input_format]].new(input: input, fail_fast: fail_fast?)
    end

    def run
      begin
        parsed_input = input_parser.parse
        process_input(parsed_input)
        log_output
      rescue ::Parsers::Errors::FailFastError => e
        puts "Parser failed fast on #{e.message}"
      end
    end

    def process_input(parsed_input); end

    def log_output
      output_logger.log(@processor_result) if output_logger
      stdout_logger.log(@processor_result) if stdout_logger
    end
  end
end
