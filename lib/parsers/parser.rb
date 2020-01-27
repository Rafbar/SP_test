module Parsers
  class Parser
    attr_accessor :file_name, :fail_fast

    def initialize(input: 'webserver.log', fail_fast: false)
      @file_name = input
      @fail_fast = fail_fast
    end
  end
end
