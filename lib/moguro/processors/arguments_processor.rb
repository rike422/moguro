# frozen_string_literal: true

module Moguro
  module Processors
    class ArgumentsProcessor < ::Parser::AST::Processor
      attr_reader :rule

      def initialize(klass, clause)
        @klass = klass
        @clause = clause
        super()
      end

      def on_const(node)
        symbol = node.children.last
        validator = Moguro::Types.get_type_validator_from_const(get_const(symbol))
        @array_processor = nil
        @clause.add_type(validator)
        super node
      end

      def on_nil(_node)
        validator = Moguro::Types.get_type_validator_from_const(nil)
        @clause.add_type(validator)
      end

      def on_send(node)
        return unless node.children[1] == :[]
        @clause.pop_type
        @clause.add_type(
          Moguro::Processors::EnumerableProcessor.generate_type_validator(node, @klass)
        )
      end

      private

      def get_const(symbol)
        @klass.const_get(symbol)
      end
    end
  end
end
