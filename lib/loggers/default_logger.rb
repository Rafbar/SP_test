module Loggers
  class DefaultLogger < Logger
    def log(result)
      open_file
      result.each do |key, value|
        log_block(key, value)
      end
      close_file
    end

    def log_block(key, value)
      @file.write "#{key}\n"
      value.each do |value_pair| 
        @file.write "url: #{value_pair[0]}, value: #{value_pair[1]}\n"
      end 
    end

    def open_file
      @file = File.open(@file_name, 'w+')
    end

    def close_file
      @file.close
    end
  end
end
