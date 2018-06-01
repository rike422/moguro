# frozen_string_literal: true

module Moguro
  module Types
    ###
    # Fake Boolean class for type definition
    # @since 0.0.1
    ###
    class Boolean < Base
      ###
      # validate value type
      # TrueClass or FalseClass
      # @since 0.0.1
      ###
      def valid?(val)
        val.is_a?(TrueClass) || val.is_a?(FalseClass)
      end

      ###
      # Type name for error message
      # @since 0.0.1
      # @private
      ###
      def type
        'TrueClass or FalseClass'
      end
    end
  end
end
