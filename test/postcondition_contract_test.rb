# frozen_string_literal: true

require 'test_helper'

class MoguroPostConditionContractTest < Minitest::Test
  def test_return_value_at_one
    s = MockPostConditionClass.new
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
        Value guarded in: MockPostConditionClass::one
        At: #{method_position(MockPostConditionClass, :one)}
    MES
  )
  end

  def test_return_value_two
    s = MockPostConditionClass.new
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
        Value guarded in: MockPostConditionClass::two
        At: #{method_position(MockPostConditionClass, :two)}
    MES
  )

    e2 = assert_raises Moguro::Errors::ReturnValueTypeMismatchError do
      s.two('a', 2)
    end

    assert_equal(e2.message, <<~"MES".chomp
      ReturnValueTypeError => Type MissMatch: b is expected (String) actual 2(Integer)
        Expected: [a: (String), b: (String)]
        Actual: [a: a(String), b: 2(Integer)]
        Value guarded in: MockPostConditionClass::two
        At: #{method_position(MockPostConditionClass, :two)}
    MES
  )
  end

  def test_return_value_bool
    s = MockPostConditionClass.new
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
        Value guarded in: MockPostConditionClass::bool
        At: #{method_position(MockPostConditionClass, :bool)}
    MES
  )

    e2 = assert_raises Moguro::Errors::ReturnValueTypeMismatchError do
      s.bool(true, b: 2)
    end

    assert_equal(e2.message, <<~"MES".chomp
      ReturnValueTypeError => Type MissMatch: b is expected (TrueClass or FalseClass) actual 2(Integer)
        Expected: [a: (TrueClass or FalseClass), b: (TrueClass or FalseClass)]
        Actual: [a: true(TrueClass), b: 2(Integer)]
        Value guarded in: MockPostConditionClass::bool
        At: #{method_position(MockPostConditionClass, :bool)}
    MES
  )
  end

  def test_return_value_array
    s = MockPostConditionClass.new
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
        Value guarded in: MockPostConditionClass::array
        At: #{method_position(MockPostConditionClass, :array)}
    MES
  )

    e2 = assert_raises Moguro::Errors::ReturnValueTypeMismatchError do
      s.array(['a'], b: 'a')
    end
    assert_equal(e2.message, <<~"MES".chomp
      ReturnValueTypeError => Type MissMatch: b is expected (Array<Integer|String>) actual a(String)
        Expected: [a: (Array), b: (Array<Integer|String>)]
        Actual: [a: [\"a\"](Array<String>), b: a(String)]
        Value guarded in: MockPostConditionClass::array
        At: #{method_position(MockPostConditionClass, :array)}
    MES
  )

    e3 = assert_raises Moguro::Errors::ReturnValueTypeMismatchError do
      s.array(['a'], b: ['a', 3, {}])
    end
    assert_equal(e3.message, <<~"MES".chomp
      ReturnValueTypeError => Type MissMatch: b is expected (Array<Integer|String>) actual [\"a\", 3, {}](Array<String|Integer|Hash>)
        Expected: [a: (Array), b: (Array<Integer|String>)]
        Actual: [a: [\"a\"](Array<String>), b: [\"a\", 3, {}](Array<String|Integer|Hash>)]
        Value guarded in: MockPostConditionClass::array
        At: #{method_position(MockPostConditionClass, :array)}
    MES
  )
  end
end
