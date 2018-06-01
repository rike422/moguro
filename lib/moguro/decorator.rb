# frozen_string_literal: true

module Moguro
  ###
  # Provide contract programming feature to the class that included this module.
  # Validates the arguments to the method, and validates the return value of the method.
  # And you arbitrary test possible by Assertion library.
  # @since 0.0.1
  ###
  module Decorator
    CONTRACT_CONTAINER = Struct.new(:pre, :post)

    def self.included(klass)
      klass.extend(ClassMethods)
      klass.include(Moguro::Types)
      # @todo
      return unless Moguro.enabled?
      require 'test/unit/assertions'
      klass.include(Test::Unit::Assertions)
      klass.extend(Test::Unit::Assertions)
    end

    module ClassMethods
      def singleton_method_added(name)
        return super unless Moguro.enabled? && contract_handler.validatable?
        super
        contract_handler.handle_singleton_method(name)
      end

      def method_added(name)
        return super unless Moguro.enabled? && contract_handler.validatable?
        super
        contract_handler.handle_method(name)
      end

      ###
      # Validates the arguments to the method
      # @since 0.0.1
      # @param [Lambda|Proc] callback
      # @return [Void]
      #
      def pre_c(callback)
        return unless Moguro.enabled?
        contract_handler.contract_arguments(callback)
      end

      ###
      # Validates the arguments to the method
      # @since 0.0.1
      # @param [Lambda|Proc] callback
      # @return [Void]
      ###
      def post_c(callback)
        return unless Moguro.enabled?
        contract_handler.contract_return_value(callback)
      end

      ###
      # Validates the arguments to the method
      # @since 0.0.1
      # @param [Lambda|Proc] callback
      # @return [Void]
      ##
      def contract_handler
        @contract_handler ||= Moguro::Handlers::ClassHandler.new(self)
      end
    end
  end
end
