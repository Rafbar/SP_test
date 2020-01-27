module Parsers
  module Errors
    class FailFastError < StandardError
      def attributes
        {
          klass: self.class.to_s,
          message: self.message
        }
      end
    end
  end
end
