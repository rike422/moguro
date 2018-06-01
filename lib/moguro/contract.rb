# frozen_string_literal: true

module Moguro
  ###
  # Contract of class state
  # @since 0.0.1
  # @abstract
  ###
  class Contract
    attr_reader :method

    def initialize(klass, callback, method)
      @klass = klass
      @type_clauses = Moguro::Processors::ContractProcessor.generate_type_validator(callback, klass)
      @cb = callback
      @method = method
    end

    def verify!(instance, args)
      values = extractor.extract(args)
      @type_clauses.verify!(values)
      instance.instance_exec(values.to_h, &@cb)
    end

    def extractor
      raise NotImplementedError
    end
  end

  class PreconditionContract < Contract
    def initialize(klass, callback, method)
      super(klass, callback, method)
    end

    def verify!(instance, args)
      super
    rescue Moguro::Errors::TypeMismatchError => e
      raise Moguro::Errors::ArgumentsTypeMismatchError.new(e, @klass, method)
    rescue => e
      raise e
    end

    def extractor
      @extractor ||= Moguro::Extractor::ArgumentsExtractor.new(method.parameters)
    end
  end

  class PostconditionContract < Contract
    def initialize(klass, callback, method)
      super(klass, callback, method)
    end

    def verify!(instance, args)
      super
    rescue Moguro::Errors::TypeMismatchError => e
      raise Moguro::Errors::ReturnValueTypeMismatchError.new(e, @klass, method)
    rescue => e
      raise e
    end

    def extractor
      @extractor ||= Moguro::Extractor::ReturnValueExtractor.new(
        @cb.parameters
      )
    end
  end
end
