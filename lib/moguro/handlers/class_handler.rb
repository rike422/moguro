# frozen_string_literal: true

module Moguro
  module Handlers
    # Handler for method added event
    # @private
    # @since 0.0.1
    # @attr_reader [Class] binding class
    class ClassHandler
      attr_reader :klass

      def initialize(klass)
        @klass = klass
        @instance_handlers = {}
        @class_handlers = {}
        @arguments_contract = nil
        @return_value_contract = nil
      end

      def handle_singleton_method(name)
        @class_handlers[name] ||= SingletonMethodHandler.new(
          self,
          name,
          arguments_contract: @arguments_contract,
          return_value_contract: @return_value_contract
        )
        clear_validator
        m = @class_handlers[name].module
        @klass.singleton_class.class_eval { prepend(m) }
      end

      def handle_method(name)
        @instance_handlers[name] = MethodHandler.new(
          self,
          name,
          arguments_contract: @arguments_contract,
          return_value_contract: @return_value_contract
        )
        clear_validator
        @klass.prepend(@instance_handlers[name].module)
      end

      def contract_arguments(callback)
        @arguments_contract = callback
      end

      def contract_return_value(callback)
        @return_value_contract = callback
      end

      def validatable?
        !@arguments_contract.nil? || !@return_value_contract.nil?
      end

      def _get_class_method_handler(name)
        @class_handlers[name]
      end

      def _get_instance_method_handler(name)
        @instance_handlers[name]
      end

      private

      def clear_validator
        @arguments_contract = nil
        @return_value_contract = nil
      end
    end
  end
end
