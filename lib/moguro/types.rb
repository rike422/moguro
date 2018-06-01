# frozen_string_literal: true

module Moguro
  module Types
    Result = Struct.new(:emumerable_validator, :valid?)
    class << self
      def get_type_validator_from_const(type)
        if type == Moguro::Types::Boolean
          type.new
        elsif type.nil?
          Nil.new
        elsif type == ::Array || type.include?(::Enumerable)
          Enumerable.new(type)
        else
          Skin.new(type)
        end
      end
    end

    ###
    # Type match class
    # @private
    # @since 0.0.1
    # @abstract
    class Base
      def valid?(_p)
        raise NotImplementedError
      end
    end
  end
end

require_relative 'types/skin'
require_relative 'types/enumerable'
require_relative 'types/boolean'
require_relative 'types/nil'
require_relative 'types/any'
