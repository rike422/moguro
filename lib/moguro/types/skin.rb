# frozen_string_literal: true

module Moguro
  module Types
    ###
    # The thin wrapper class for some instance object
    # @since 0.0.1
    ###
    class Skin < SimpleDelegator
      def initialize(klass)
        @klass = klass
        super(@klass)
      end

      def valid?(val)
        val.is_a?(@klass)
      end

      ###
      # Class name for error message
      # @since 0.0.1
      # @private
      ###
      def type
        @klass
      end
    end
  end
end
