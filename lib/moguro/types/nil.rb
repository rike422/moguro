# frozen_string_literal: true

module Moguro
  module Types
    ###
    # @since 0.0.1
    # NilClass Wrapper
    class Nil < Base
      def valid?(p)
        p.nil?
      end

      def type
        'nil'
      end
    end
  end
end
