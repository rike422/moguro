# frozen_string_literal: true

module Moguro
  module Errors
    ###
    # @private
    # Base class for Errors
    # If default failure callback is used it stores failure data
    ###
    class BaseError < ::ArgumentError
    end

    ###
    # Type miss match error class for Arguments and return value
    # @attribute :actual, :expected
    class TypeMismatchError < BaseError
      attr_accessor :actual, :expected
      attr_reader :failure_clause, :failure_value

      def initialize(failure_clause, failure_value)
        @failure_clause = failure_clause
        @failure_value = failure_value
        @actual = nil
        @expected = nil
      end

      def failure_detail
        <<~"DETAIL".chomp
          Expected: #{@expected}
            Actual: #{@actual}
        DETAIL
      end

      def failure_summary
        "Type MissMatch: #{@failure_clause.key} is expected #{@failure_clause.type_inspect} actual #{@failure_value.type_inspect}"
      end
    end

    class ArgumentsTypeMismatchError < BaseError
      def initialize(type_mismatch_error, klass, method)
        @e = type_mismatch_error
        @klass = klass
        @method = method
        super(failure_message)
      end

      def failure_title
        'ArgumentsTypeError'
      end

      def failure_message
        <<~"MESSAGE".chomp
          #{failure_title} => #{@e.failure_summary}
            #{@e.failure_detail}
            #{failure_location}
        MESSAGE
      end

      def failure_location
        <<~"LOCATION".chomp
          Value guarded in: #{@klass}::#{@method.name}
            At: #{@method.position}
        LOCATION
      end
    end

    class ReturnValueTypeMismatchError < BaseError
      def initialize(type_mismatch_error, klass, method)
        @e = type_mismatch_error
        @klass = klass
        @method = method
        super(failure_message)
      end

      def failure_title
        'ReturnValueTypeError'
      end

      def failure_message
        <<~"MESSAGE".chomp
          #{failure_title} => #{@e.failure_summary}
            #{@e.failure_detail}
            #{failure_location}
        MESSAGE
      end

      def failure_location
        <<~"LOCATION".chomp
          Value guarded in: #{@klass}::#{@method.name}
            At: #{@method.position}
        LOCATION
      end
    end
    class ArgumentError < BaseError
    end
  end
end
