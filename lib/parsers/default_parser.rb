module Parsers
  class DefaultParser < Parser
    def parse
      open_file
      @result = parse_file
      close_file
      @result
    end

    def open_file
      begin
        @file = File.open(@file_name, 'r')
      rescue Errno::ENOENT => e
        raise Errors::FailFastError.new("#{e.message}")
      end
    end

    def close_file
      @file.close
    end

    def parse_file
      lines = @file.readlines
      result = lines.map{|line| parse_line(line)}
      result
    end

    def parse_line(line)
      split = line.strip.split(' ')
      if verify_url(split[0]) && verify_ip(split[1])
        {url: split[0], ip: split[1]}
      else
        raise Errors::FailFastError.new("Failed parsing on: #{line}") if @fail_fast
        {error: "failed_parse", line: line.strip}
      end
    end

    def verify_url(url)
      url =~ /^(\/\w+)+$/
    end

    def verify_ip(ip)
      ip =~ /^\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}$/
    end
  end
end
