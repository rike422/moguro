# frozen_string_literal: true

module Moguro
  module Handlers
    class MethodHandler
      def initialize(class_handler, name, arguments_contract: nil, return_value_contract: nil)
        @class_handler = class_handler
        @name = name
        @arguments_contract =
          if arguments_contract.nil?
            arguments_contract
          else
            PreconditionContract.new(klass, arguments_contract, reference)
          end
        @return_value_contract =
          if return_value_contract.nil?
            return_value_contract
          else
            PostconditionContract.new(klass, return_value_contract, reference)
          end
      end

      def module
        m = Module.new

        arguments_contract = @arguments_contract
        return_value_contract = @return_value_contract

        arguments_contract_cb = lambda { |klass, args|
          arguments_contract&.verify!(klass, args)
        }

        return_value_contract_cb = lambda { |klass, results|
          return_value_contract&.verify!(klass, results)
        }
        name = @name
        m.module_eval do
          define_method(name) do |*args, &block|
            arguments_contract_cb.call(self, args)
            *results = super(*args, &block)
            return_value_contract_cb.call(self, results)
          end
        end
        m
      end

      def reference
        @reference ||= MethodReference.new(
          method
        )
      end

      private

      def parameters
        @parameters ||= method.parameters
      end

      def method
        @method ||= klass.instance_method(@name)
      end

      def klass
        @klass ||= @class_handler.klass
      end
    end

    class SingletonMethodHandler < MethodHandler
      def method
        @method ||= klass.method(@name)
      end
    end
  end
end
