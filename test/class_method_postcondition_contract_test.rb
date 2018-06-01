# frozen_string_literal: true

require 'test_helper'

class MoguroClassMethodPostConditionContractTest < Minitest::Test
  def test_return_value_at_one
    s = MockClassMethodPostConditionClass
    assert_output("a\npost: a\n") do
      s.one('a')
    end

    e = assert_raises Moguro::Errors::ReturnValueTypeMismatchError do
      s.one(1)
    end

    assert_equal(e.message, <<~"MES".chomp
      ReturnValueTypeError => Type MissMatch: a is expected (String) actual 1(Integer)
        Expected: [a: (String)]
        Actual: [a: 1(Integer)]
        Value guarded in: MockClassMethodPostConditionClass::one
        At: #{class_method_position(MockClassMethodPostConditionClass, :one)}
    MES
  )
  end

  def test_return_value_two
    s = MockClassMethodPostConditionClass
    assert_output("a and b\npost: a and b\n") do
      s.two('a', 'b')
    end

    e = assert_raises Moguro::Errors::ReturnValueTypeMismatchError do
      s.two(1, 'b')
    end

    assert_equal(e.message, <<~"MES".chomp
      ReturnValueTypeError => Type MissMatch: a is expected (String) actual 1(Integer)
        Expected: [a: (String), b: (String)]
        Actual: [a: 1(Integer), b: b(String)]
        Value guarded in: MockClassMethodPostConditionClass::two
        At: #{class_method_position(MockClassMethodPostConditionClass, :two)}
    MES
  )

    e2 = assert_raises Moguro::Errors::ReturnValueTypeMismatchError do
      s.two('a', 2)
    end

    assert_equal(e2.message, <<~"MES".chomp
      ReturnValueTypeError => Type MissMatch: b is expected (String) actual 2(Integer)
        Expected: [a: (String), b: (String)]
        Actual: [a: a(String), b: 2(Integer)]
        Value guarded in: MockClassMethodPostConditionClass::two
        At: #{class_method_position(MockClassMethodPostConditionClass, :two)}
    MES
  )
  end

  def test_return_value_bool
    s = MockClassMethodPostConditionClass
    assert_output("true and false\npost: true and false\n") do
      s.bool(true, b: false)
    end

    e = assert_raises Moguro::Errors::ReturnValueTypeMismatchError do
      s.bool(1, b: false)
    end

    assert_equal(e.message, <<~"MES".chomp
      ReturnValueTypeError => Type MissMatch: a is expected (TrueClass or FalseClass) actual 1(Integer)
        Expected: [a: (TrueClass or FalseClass), b: (TrueClass or FalseClass)]
        Actual: [a: 1(Integer), b: false(FalseClass)]
        Value guarded in: MockClassMethodPostConditionClass::bool
        At: #{class_method_position(MockClassMethodPostConditionClass, :bool)}
    MES
  )

    e2 = assert_raises Moguro::Errors::ReturnValueTypeMismatchError do
      s.bool(true, b: 2)
    end

    assert_equal(e2.message, <<~"MES".chomp
      ReturnValueTypeError => Type MissMatch: b is expected (TrueClass or FalseClass) actual 2(Integer)
        Expected: [a: (TrueClass or FalseClass), b: (TrueClass or FalseClass)]
        Actual: [a: true(TrueClass), b: 2(Integer)]
        Value guarded in: MockClassMethodPostConditionClass::bool
        At: #{class_method_position(MockClassMethodPostConditionClass, :bool)}
    MES
  )
  end

  def test_return_value_array
    s = MockClassMethodPostConditionClass
    assert_output("[1, 2]/[\"a\", 3]\npost: [1, 2]/[\"a\", 3]\n") do
      s.array([1, 2], b: ['a', 3])
    end

    e = assert_raises Moguro::Errors::ReturnValueTypeMismatchError do
      s.array(1, b: ['a', 3])
    end
    assert_equal(e.message, <<~"MES".chomp
      ReturnValueTypeError => Type MissMatch: a is expected (Array) actual 1(Integer)
        Expected: [a: (Array), b: (Array<Integer|String>)]
        Actual: [a: 1(Integer), b: [\"a\", 3](Array<String|Integer>)]
        Value guarded in: MockClassMethodPostConditionClass::array
        At: #{class_method_position(MockClassMethodPostConditionClass, :array)}
    MES
  )

    e2 = assert_raises Moguro::Errors::ReturnValueTypeMismatchError do
      s.array(['a'], b: 'a')
    end
    assert_equal(e2.message, <<~"MES".chomp
      ReturnValueTypeError => Type MissMatch: b is expected (Array<Integer|String>) actual a(String)
        Expected: [a: (Array), b: (Array<Integer|String>)]
        Actual: [a: [\"a\"](Array<String>), b: a(String)]
        Value guarded in: MockClassMethodPostConditionClass::array
        At: #{class_method_position(MockClassMethodPostConditionClass, :array)}
    MES
  )

    e3 = assert_raises Moguro::Errors::ReturnValueTypeMismatchError do
      s.array(['a'], b: ['a', 3, {}])
    end
    assert_equal(e3.message, <<~"MES".chomp
      ReturnValueTypeError => Type MissMatch: b is expected (Array<Integer|String>) actual [\"a\", 3, {}](Array<String|Integer|Hash>)
        Expected: [a: (Array), b: (Array<Integer|String>)]
        Actual: [a: [\"a\"](Array<String>), b: [\"a\", 3, {}](Array<String|Integer|Hash>)]
        Value guarded in: MockClassMethodPostConditionClass::array
        At: #{class_method_position(MockClassMethodPostConditionClass, :array)}
    MES
  )
  end
end
