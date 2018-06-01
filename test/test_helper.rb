# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('../lib', __dir__)
require 'moguro'

require 'minitest/autorun'
require 'minitest-power_assert'
require 'fixtures/fixtures'

def method_position(klass, method)
  klass.contract_handler._get_instance_method_handler(method).reference.position
end

def class_method_position(klass, method)
  klass.contract_handler._get_class_method_handler(method).reference.position
end
