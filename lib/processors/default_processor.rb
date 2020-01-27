module Processors
  class DefaultProcessor < Processor
    def process_input(parsed_input)
      preprocessed = {}
      errors = parsed_input.select{|x| x[:error]}.map{|error| [error[:error], error[:line]]}
      parsed_input.select{|x| !x[:error]}.each do |line|
        if preprocessed[line[:url]]
          preprocessed[line[:url]] << line[:ip]
        else
          preprocessed[line[:url]] = [line[:ip]]
        end
      end
      @processor_result = { 
        "All visits" => all_visits(preprocessed),
        "Unique visits" => unique_visits(preprocessed),
        "Errors" => errors
      }
    end

    def unique_visits(preprocessed)
      post_process = preprocessed.map do |key, value|
        [key, value.uniq.size]
      end
      post_process.sort_by{|x| x[1]}.reverse
    end

    def all_visits(preprocessed)
      post_process = preprocessed.map do |key, value|
        [key, value.size]
      end
      post_process.sort_by{|x| x[1]}.reverse
    end
  end
end
