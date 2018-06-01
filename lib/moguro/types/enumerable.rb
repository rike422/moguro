# frozen_string_literal: true

module Moguro
  module Types
    ###
    # Array type validator
    # @since 0.0.1
    # @private
    ###
    class Enumerable < Base
      def initialize(klass)
        @content_type = []
        @klass = klass
      end

      def add_content_type(type)
        @content_type << type
      end

      def valid?(val)
        eumerable?(val) && (val.empty? || content_type_valid?(val))
      end

      def type
        if @content_type.empty?
          @klass.to_s
        else
          "#{@klass}<#{@content_type.join('|')}>"
        end
      end

      private

      def eumerable?(val)
        val.is_a?(@klass)
      end

      def content_type_valid?(val)
        return true if @content_type.empty?

        val.all? do |v|
          @content_type.any? { |type| type.valid?(v) }
        end
      end
    end
  end
end
