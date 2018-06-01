# frozen_string_literal: true

module Moguro
  module Types
    ###
    #
    # @since 0.0.1
    class Any < Base
      def valid?(_val)
        true
      end

      ###
      # Type name for error message
      # @since 0.0.1
      # @private
      ###
      def type
        'Any'
      end
    end
  end
end
