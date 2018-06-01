# frozen_string_literal: true

module Moguro
  module Extractor
    class ReturnValueExtractor
      def initialize(parameters)
        @parameters = parameters
      end

      def extract(return_value)
        @parameters.each_with_object(Values.new).with_index do |(params, values), i|
          key = params[1]
          val = return_value[i]
          values.add_value(key, val, missing: val.nil?)
        end
      end
    end
  end
end
