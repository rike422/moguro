# frozen_string_literal: true

module Moguro
  module Extractor
    class ArgumentsExtractor
      def initialize(parameters)
        @parameters = parameters
      end

      def extract(args)
        opt = args.last.is_a?(Hash) ? args.last : nil
        @parameters.each_with_object(Values.new).with_index do |(params, values), i|
          arg_type = params[0]
          key = params[1]
          case arg_type
          when :req
            val = args[i]
            values.add_value(key, val)
          when :keyreq
            if opt&.key?(key)
              val = opt[key]
              values.add_value(key, val)
            else
              values.add_value(key, val, missing: true)
            end
          when :key
            val = opt[key]
            values.add_value(key, val)
          when :opt
            values.add_value(key, args[i])
          end
        end
      end
    end
  end
end
