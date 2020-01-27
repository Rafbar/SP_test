module Loggers
  class Logger
    attr_accessor :file_name

    def initialize(file_name: nil)
      @file_name = file_name
    end
  end
end
