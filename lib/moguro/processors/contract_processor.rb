# frozen_string_literal: true

module Moguro
  module Processors
    class ContractParser
      def initialize(str)
        @str = str
      end

      def parse
        ::Parser::CurrentRuby.parse(@str)
      end
    end

    class ContractProcessor < ::Parser::AST::Processor
      attr_reader :clauses
      Rule = Struct.new(:key, :clauses)

      def initialize(klass)
        @current_arg = nil
        @klass = klass
        @clauses = Clauses.new
        super()
      end

      def on_kwarg(node)
        process_args(node)
        super node
      end

      def on_kwoptarg(node)
        process_args(node)
        super node
      end

      class << self
        def generate_type_validator(function, klass)
          ast = ContractParser.new(
            function.source
          ).parse

          processor = ContractProcessor.new(klass)
          processor.process(ast)
          processor.clauses
        end
      end

      private

      def process_args(node)
        argument_key, _other = *node
        rotate_rule(argument_key)
        processor = ArgumentsProcessor.new(@klass, current_clause)
        processor.process(node)
      end

      def rotate_rule(argument_key)
        @clauses.add_verified_argument(argument_key)
      end

      def current_clause
        clauses.last
      end
    end
  end
end
