module Processors
  class DefaultProcessor < Processor
    def run
      begin
        parsed_input = input_parser.parse
      rescue ::Parsers::Errors::FailFastError => e
        puts "Parser failed fast on #{e.message}"
      end
    end
  end
end
