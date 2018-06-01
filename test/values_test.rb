# frozen_string_literal: true

require 'test_helper'

class MoguroValuesTest < Minitest::Test
  def test_add_value_is_create_a_value_object
    values = Moguro::Values.new
    assert { values.empty? }
    values.add_value(:test_a, 'value')
    assert { values.length == 1 }
    values.add_value(:test_b, nil, missing: true)

    assert do
      values[0] == 'value'
      values[0].is_a?(String)
      values[0].key == :test_a
      values[0].missing? == false
    end

    assert do
      values[1].nil?
      values[1].key == :test_b
      values[1].is_a?(NilClass)
      values[1].missing? == true
    end
  end

  def test_to_h_is_convert_datatype_from_value_sto_hash_object
    values = Moguro::Values.new
    values.add_value(:test_a, 'value')
    values.add_value(:test_b, nil, missing: true)
    values.add_value(:test_c, 1)

    assert do
      values.to_h == {
        test_a: 'value',
        test_b: nil,
        test_c: 1
      }
    end
  end
end
