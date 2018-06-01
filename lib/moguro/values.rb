# frozen_string_literal: true

module Moguro
  ###
  # Wrapper class for Arguments
  # @since 0.0.1
  # @private
  ###
  class Values < DelegateClass(Array)
    def initialize
      super([])
    end

    def to_h
      each_with_object({}) do |value_class, hash|
        hash[value_class.key] = value_class.value
      end
    end

    def add_value(key, value, missing: false)
      self << Value.new(key, value, missing: missing)
    end

    def inspect
      map(&:inspect)
    end
  end

  ###
  # Wrapper class for Arguments value
  # @since 0.0.1
  # @private
  ###
  class Value < SimpleDelegator
    attr_reader :key, :value

    def initialize(key, value, missing: false)
      @key = key
      @value = value
      @missing = missing
      super(@value)
    end

    def missing?
      @missing
    end

    def class
      @value.class
    end

    def is_a?(val)
      @value.is_a?(val)
    end

    def nil?
      @value.nil?
    end

    def inspect
      "#{key}: #{type_inspect}"
    end

    def type_inspect
      if @value.class.include?(Enumerable) && !@value.empty?
        "#{value}(#{value.class}<#{@value.map(&:class).uniq.join('|')}>)"
      else
        "#{value}(#{value.class})"
      end
    end
  end
end
