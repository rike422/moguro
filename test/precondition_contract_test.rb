# frozen_string_literal: true

require 'test_helper'

class PreConditionContractTest < Minitest::Test
  def test_call_pre_contract_validator
    s = MockPreConditionClass.new
    assert_output("a and b\na + 1 and b + 1\n") do
      s.plain('a', 'b')
    end

    assert_output("1 and 2\n1 + 1 and 2 + 1\n") do
      s.opt(1, 2)
    end

    assert_output("1 and 2 and 3\n1 + 1 and 2 + 1 and 3 + 1\n") do
      s.kwd(a: 1, b: 2, c: 3)
    end

    assert_output("1 and 2 and 3\n1 + 1 and 2 + 1 and 3 + 1\n") do
      s.mix(1, 2, c: 3)
    end
  end

  def test_call_pre_contract_validator_and_raise_type_error
    s = MockPreConditionClass.new

    a = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.plain(1, 'b')
    end

    assert_equal(a.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: a is expected (String) actual 1(Integer)
        Expected: [a: (String), b: (String)]
        Actual: [a: 1(Integer), b: b(String)]
        Value guarded in: MockPreConditionClass::plain
        At: #{method_position(MockPreConditionClass, :plain)}
    MES
  )
    b = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.plain('a', 1)
    end

    assert_equal(b.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: b is expected (String) actual 1(Integer)
        Expected: [a: (String), b: (String)]
        Actual: [a: a(String), b: 1(Integer)]
        Value guarded in: MockPreConditionClass::plain
        At: #{method_position(MockPreConditionClass, :plain)}
    MES
  )

    multi = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.plain(1, 1)
    end

    assert_equal(multi.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: a is expected (String) actual 1(Integer)
        Expected: [a: (String), b: (String)]
        Actual: [a: 1(Integer), b: 1(Integer)]
        Value guarded in: MockPreConditionClass::plain
        At: #{method_position(MockPreConditionClass, :plain)}
    MES
  )
  end

  def test_call_pre_contract_validator_and_raise_type_error_opt
    s = MockPreConditionClass.new

    a = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.opt('a', 1)
    end

    assert_equal(a.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: a is expected (Integer) actual a(String)
        Expected: [a: (Integer), b: (Integer)]
        Actual: [a: a(String), b: 1(Integer)]
        Value guarded in: MockPreConditionClass::opt
        At: #{method_position(MockPreConditionClass, :opt)}
    MES
  )

    b = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.opt(1, 'b')
    end

    assert_equal(b.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: b is expected (Integer) actual b(String)
        Expected: [a: (Integer), b: (Integer)]
        Actual: [a: 1(Integer), b: b(String)]
        Value guarded in: MockPreConditionClass::opt
        At: #{method_position(MockPreConditionClass, :opt)}
    MES
  )

    multi = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.opt('a', 'b')
    end

    assert_equal(multi.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: a is expected (Integer) actual a(String)
        Expected: [a: (Integer), b: (Integer)]
        Actual: [a: a(String), b: b(String)]
        Value guarded in: MockPreConditionClass::opt
        At: #{method_position(MockPreConditionClass, :opt)}
    MES
  )
  end

  def test_call_pre_contract_validator_and_raise_type_error_kwd
    s = MockPreConditionClass.new

    a = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.kwd(a: 'a', b: 2, c: 3)
    end

    assert_equal(a.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: a is expected (Integer) actual a(String)
        Expected: [a: (Integer), b: (Integer), c: (Any)]
        Actual: [a: a(String), b: 2(Integer), c: 3(Integer)]
        Value guarded in: MockPreConditionClass::kwd
        At: #{method_position(MockPreConditionClass, :kwd)}
    MES
  )

    b = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.kwd(a: 1, b: 'b', c: 3)
    end

    assert_equal(b.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: b is expected (Integer) actual b(String)
        Expected: [a: (Integer), b: (Integer), c: (Any)]
        Actual: [a: 1(Integer), b: b(String), c: 3(Integer)]
        Value guarded in: MockPreConditionClass::kwd
        At: #{method_position(MockPreConditionClass, :kwd)}
    MES
  )
  end

  def test_call_pre_contract_validator_and_raise_type_error_mix
    s = MockPreConditionClass.new

      a = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
        s.mix('a', 2, c: 3)
      end

    assert_equal(a.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: a is expected (Integer) actual a(String)
        Expected: [a: (Integer), b: (Integer), c: (Integer)]
        Actual: [a: a(String), b: 2(Integer), c: 3(Integer)]
        Value guarded in: MockPreConditionClass::mix
        At: #{method_position(MockPreConditionClass, :mix)}
    MES
  )

    b = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.mix(1, 'b', c: 3)
    end

    assert_equal(b.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: b is expected (Integer) actual b(String)
        Expected: [a: (Integer), b: (Integer), c: (Integer)]
        Actual: [a: 1(Integer), b: b(String), c: 3(Integer)]
        Value guarded in: MockPreConditionClass::mix
        At: #{method_position(MockPreConditionClass, :mix)}
    MES
  )

    multi = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.mix(1, 2, c: 'c')
    end

    assert_equal(multi.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: c is expected (Integer) actual c(String)
        Expected: [a: (Integer), b: (Integer), c: (Integer)]
        Actual: [a: 1(Integer), b: 2(Integer), c: c(String)]
        Value guarded in: MockPreConditionClass::mix
        At: #{method_position(MockPreConditionClass, :mix)}
    MES
  )
  end

  def test_nullable_type
    s = MockPreConditionClass.new

    assert_output(" and  and \n + 1 and  + 1 and  + 1\n") do
      s.nullable(nil, nil, c: nil)
    end

    assert_output("1 and  and \n1 + 1 and  + 1 and  + 1\n") do
      s.nullable(1, nil, c: nil)
    end

    assert_output("1 and 2 and \n1 + 1 and 2 + 1 and  + 1\n") do
      s.nullable(1, 2, c: nil)
    end

    assert_output("1 and 2 and 3\n1 + 1 and 2 + 1 and 3 + 1\n") do
      s.nullable(1, 2, c: '3')
    end

    e = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.nullable('1', 2, c: 'c')
    end

    assert_equal(e.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: a is expected (Integer|nil) actual 1(String)
        Expected: [a: (Integer|nil), b: (Integer|nil), c: (String|nil)]
        Actual: [a: 1(String), b: 2(Integer), c: c(String)]
        Value guarded in: MockPreConditionClass::nullable
        At: #{method_position(MockPreConditionClass, :nullable)}
    MES
  )

    e2 = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.nullable(1, 2, c: 3)
    end

    assert_equal(e2.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: c is expected (String|nil) actual 3(Integer)
        Expected: [a: (Integer|nil), b: (Integer|nil), c: (String|nil)]
        Actual: [a: 1(Integer), b: 2(Integer), c: 3(Integer)]
        Value guarded in: MockPreConditionClass::nullable
        At: #{method_position(MockPreConditionClass, :nullable)}
    MES
  )
  end

  def test_bool
    s = MockPreConditionClass.new

    assert_output("true and false\nfalse and true\n") do
      s.bool(true, b: false)
    end

    e = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.bool('a', b: false)
    end

    assert_equal(e.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: a is expected (TrueClass or FalseClass) actual a(String)
        Expected: [a: (TrueClass or FalseClass), b: (TrueClass or FalseClass)]
        Actual: [a: a(String), b: false(FalseClass)]
        Value guarded in: MockPreConditionClass::bool
        At: #{method_position(MockPreConditionClass, :bool)}
    MES
  )

    e2 = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.bool(true, b: 'b')
    end

    assert_equal(e2.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: b is expected (TrueClass or FalseClass) actual b(String)
        Expected: [a: (TrueClass or FalseClass), b: (TrueClass or FalseClass)]
        Actual: [a: true(TrueClass), b: b(String)]
        Value guarded in: MockPreConditionClass::bool
        At: #{method_position(MockPreConditionClass, :bool)}
    MES
  )
  end

  def test_array
    s = MockPreConditionClass.new
    assert_output("a,b/c,d\na,b+c,d\n") do
      s.array(%w[a b], b: %w[c d])
    end

    e = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.array('a', b: [])
    end

    assert_equal(e.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: a is expected (Array) actual a(String)
        Expected: [a: (Array), b: (Array<Integer|String>)]
        Actual: [a: a(String), b: [](Array)]
        Value guarded in: MockPreConditionClass::array
        At: #{method_position(MockPreConditionClass, :array)}
    MES
  )

    e2 = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.array([], b: 'b')
    end

    assert_equal(e2.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: b is expected (Array<Integer|String>) actual b(String)
        Expected: [a: (Array), b: (Array<Integer|String>)]
        Actual: [a: [](Array), b: b(String)]
        Value guarded in: MockPreConditionClass::array
        At: #{method_position(MockPreConditionClass, :array)}
    MES
  )

    e3 = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.array([], b: [{}, 'b', 1])
    end

    assert_equal(e3.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: b is expected (Array<Integer|String>) actual [{}, "b", 1](Array<Hash|String|Integer>)
        Expected: [a: (Array), b: (Array<Integer|String>)]
        Actual: [a: [](Array), b: [{}, "b", 1](Array<Hash|String|Integer>)]
        Value guarded in: MockPreConditionClass::array
        At: #{method_position(MockPreConditionClass, :array)}
    MES
  )
  end
end
