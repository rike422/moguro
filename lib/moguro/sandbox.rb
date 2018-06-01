# frozen_string_literal: true

module Moguro
  class SandBox
    include Test::Unit::Assertions

    def initialize(klass)
      @klass = klass
    end

    def method_missing(method_name, *args, &blk)
      @klass.__send__(method_name, *args, &blk)
    end
  end
end
