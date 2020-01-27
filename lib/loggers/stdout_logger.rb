module Loggers
  class StdoutLogger < Logger
    def log(result)
      result.each do |key, value|
        log_block(key, value)
      end
    end

    def log_block(key, value)
      puts "#{key}"
      value.each do |value_pair| 
        puts "url: #{value_pair[0]}, value: #{value_pair[1]}"
      end 
    end
  end
end
