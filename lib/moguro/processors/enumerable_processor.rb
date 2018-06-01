# frozen_string_literal: true

module Moguro
  module Processors
    class EnumerableProcessor < ::Parser::AST::Processor
      attr_reader :enumerate_validator

      def initialize(klass)
        @current_arg = nil
        @klass = klass
        @enumerate_validator = nil
        super()
      end

      def on_const(node)
        symbol = node.children.last
        type = @klass.const_get(symbol)
        if @enumerate_validator.nil?
          @enumerate_validator ||= Moguro::Types::Enumerable.new(type)
        else
          validator = Moguro::Types.get_type_validator_from_const(type)
          @enumerate_validator.add_content_type(validator)
        end
        super node
      end

      def on_send(node)
        @base_type = false if node.children[1] == :[]
        super node
      end

      private

      class << self
        def generate_type_validator(ast, klass)
          processor = EnumerableProcessor.new(klass)
          processor.process(ast)
          processor.enumerate_validator
        end
      end
    end
  end
end
