# frozen_string_literal: true

module Moguro
  # MethodReference represents original method reference that was
  # decorated by contracts.ruby. Used for instance methods.
  # This class borrowed many source code from https://github.com/egonSchiele/contracts.ruby
  # License:: https://github.com/egonSchiele/contracts.ruby/blob/master/LICENSE
  class MethodReference
    attr_reader :name

    # name - name of the method
    # method - method object
    def initialize(method)
      @name = method.name
      @method = method
    end

    # Returns method_position, delegates to Support.method_position
    def position
      file, line = @method.source_location
      if file.nil? || line.nil?
        ''
      else
        "#{file}:#{line}"
      end
    end

    def parameters
      @method.parameters
    end
  end

  # The same as MethodReference, but used for singleton methods.
  class SingletonMethodReference < MethodReference
    private

    def private?(this)
      this.private_methods.map(&:to_sym).include?(name)
    end

    def protected?(this)
      this.protected_methods.map(&:to_sym).include?(name)
    end
  end
end
