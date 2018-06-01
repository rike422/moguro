# frozen_string_literal: true

module Moguro
  class DataTypeClause
    attr_reader :key

    def initialize(key)
      @types = []
      @key = key
    end

    def add_type(type)
      @types << type
    end

    def pop_type
      @types.pop
    end

    def types
      if @types.empty?
        [Moguro::Types::Any.new]
      else
        @types
      end
    end

    def type_inspect
      klasses = types.map(&:type)
      "(#{klasses.join('|')})"
    end

    def inspect
      "#{key}: #{type_inspect}"
    end

    def verify!(val)
      return if types.empty?
      raise Moguro::Errors::TypeMismatchError.new(self, val) if types.none? { |c| c.valid?(val) }
    end
  end

  class Clauses < DelegateClass(Array)
    ###
    # @private
    ###
    def initialize
      super([])
    end

    def add_verified_argument(argument_key)
      self << DataTypeClause.new(argument_key)
    end

    ###
    # Validation arguments
    # @param args Moguro::ArgumentsExtractor::Values
    ###
    def verify!(args)
      verify_arguments!(args)
    end

    def inspect
      map(&:inspect)
    end

    private

    def verify_arguments!(args)
      verify_arguments_length!(args)
      verify_arguments_types!(args)
    end

    def verify_arguments_length!(args)
      missing_keys = args.select(&:missing?).map(&:key)
      raise Moguro::Errors::ArgumentError, "Missing required parameters at ##{@name}: #{missing_keys.join(', ')}" if missing_keys.any?
    end

    def verify_arguments_types!(args)
      each do |clause|
        args_i = args.index { |a| a.key == clause.key }
        clause.verify!(args[args_i])
      end
    rescue Moguro::Errors::TypeMismatchError => e
      e.actual = args
      e.expected = self
      raise e
    end
  end
end
