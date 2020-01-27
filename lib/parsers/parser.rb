module Parsers
  class Parser
    attr_accessor :file_name

    def initialize(input: 'webserver.log', fail_fast: false)
      @file_name = input
      @fail_fast = fail_fast
      @result = nil
    end
  end
end
