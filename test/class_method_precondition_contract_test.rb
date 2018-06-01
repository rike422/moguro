# frozen_string_literal: true

require 'test_helper'

class ClassMethodPreConditionContractTest < Minitest::Test
  def test_call_pre_contract_validator_and_raise_type_error
    s = MockClassMethodClass

    a = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.plain(1, 'b')
    end

    assert_equal(a.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: a is expected (String) actual 1(Integer)
        Expected: [a: (String), b: (String)]
        Actual: [a: 1(Integer), b: b(String)]
        Value guarded in: MockClassMethodClass::plain
        At: #{class_method_position(MockClassMethodClass, :plain)}
    MES
  )
    b = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.plain('a', 1)
    end

    assert_equal(b.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: b is expected (String) actual 1(Integer)
        Expected: [a: (String), b: (String)]
        Actual: [a: a(String), b: 1(Integer)]
        Value guarded in: MockClassMethodClass::plain
        At: #{class_method_position(MockClassMethodClass, :plain)}
    MES
  )

    multi = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.plain(1, 1)
    end

    assert_equal(multi.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: a is expected (String) actual 1(Integer)
        Expected: [a: (String), b: (String)]
        Actual: [a: 1(Integer), b: 1(Integer)]
        Value guarded in: MockClassMethodClass::plain
        At: #{class_method_position(MockClassMethodClass, :plain)}
    MES
  )
  end

  def test_call_pre_contract_validator_and_raise_type_error_opt
    s = MockClassMethodClass

    a = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.opt('a', 1)
    end

    assert_equal(a.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: a is expected (Integer) actual a(String)
        Expected: [a: (Integer), b: (Integer)]
        Actual: [a: a(String), b: 1(Integer)]
        Value guarded in: MockClassMethodClass::opt
        At: #{class_method_position(MockClassMethodClass, :opt)}
    MES
  )

    b = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.opt(1, 'b')
    end

    assert_equal(b.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: b is expected (Integer) actual b(String)
        Expected: [a: (Integer), b: (Integer)]
        Actual: [a: 1(Integer), b: b(String)]
        Value guarded in: MockClassMethodClass::opt
        At: #{class_method_position(MockClassMethodClass, :opt)}
    MES
  )

    multi = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.opt('a', 'b')
    end

    assert_equal(multi.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: a is expected (Integer) actual a(String)
        Expected: [a: (Integer), b: (Integer)]
        Actual: [a: a(String), b: b(String)]
        Value guarded in: MockClassMethodClass::opt
        At: #{class_method_position(MockClassMethodClass, :opt)}
    MES
  )
  end

  def test_call_pre_contract_validator_and_raise_type_error_kwd
    s = MockClassMethodClass

    a = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.kwd(a: 'a', b: 2, c: 3)
    end

    assert_equal(a.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: a is expected (Integer) actual a(String)
        Expected: [a: (Integer), b: (Integer), c: (Any)]
        Actual: [a: a(String), b: 2(Integer), c: 3(Integer)]
        Value guarded in: MockClassMethodClass::kwd
        At: #{class_method_position(MockClassMethodClass, :kwd)}
    MES
  )

    b = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.kwd(a: 1, b: 'b', c: 3)
    end

    assert_equal(b.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: b is expected (Integer) actual b(String)
        Expected: [a: (Integer), b: (Integer), c: (Any)]
        Actual: [a: 1(Integer), b: b(String), c: 3(Integer)]
        Value guarded in: MockClassMethodClass::kwd
        At: #{class_method_position(MockClassMethodClass, :kwd)}
    MES
  )
  end

  def test_call_pre_contract_validator_and_raise_type_error_mix
    s = MockClassMethodClass

      a = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
        s.mix('a', 2, c: 3)
      end

    assert_equal(a.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: a is expected (Integer) actual a(String)
        Expected: [a: (Integer), b: (Integer), c: (Integer)]
        Actual: [a: a(String), b: 2(Integer), c: 3(Integer)]
        Value guarded in: MockClassMethodClass::mix
        At: #{class_method_position(MockClassMethodClass, :mix)}
    MES
  )

    b = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.mix(1, 'b', c: 3)
    end

    assert_equal(b.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: b is expected (Integer) actual b(String)
        Expected: [a: (Integer), b: (Integer), c: (Integer)]
        Actual: [a: 1(Integer), b: b(String), c: 3(Integer)]
        Value guarded in: MockClassMethodClass::mix
        At: #{class_method_position(MockClassMethodClass, :mix)}
    MES
  )

    multi = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.mix(1, 2, c: 'c')
    end

    assert_equal(multi.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: c is expected (Integer) actual c(String)
        Expected: [a: (Integer), b: (Integer), c: (Integer)]
        Actual: [a: 1(Integer), b: 2(Integer), c: c(String)]
        Value guarded in: MockClassMethodClass::mix
        At: #{class_method_position(MockClassMethodClass, :mix)}
    MES
  )
  end

  def test_nullable_type
    s = MockClassMethodClass

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
        Value guarded in: MockClassMethodClass::nullable
        At: #{class_method_position(MockClassMethodClass, :nullable)}
    MES
  )

    e2 = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.nullable(1, 2, c: 3)
    end

    assert_equal(e2.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: c is expected (String|nil) actual 3(Integer)
        Expected: [a: (Integer|nil), b: (Integer|nil), c: (String|nil)]
        Actual: [a: 1(Integer), b: 2(Integer), c: 3(Integer)]
        Value guarded in: MockClassMethodClass::nullable
        At: #{class_method_position(MockClassMethodClass, :nullable)}
    MES
  )
  end

  def test_bool
    s = MockClassMethodClass

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
        Value guarded in: MockClassMethodClass::bool
        At: #{class_method_position(MockClassMethodClass, :bool)}
    MES
  )

    e2 = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.bool(true, b: 'b')
    end

    assert_equal(e2.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: b is expected (TrueClass or FalseClass) actual b(String)
        Expected: [a: (TrueClass or FalseClass), b: (TrueClass or FalseClass)]
        Actual: [a: true(TrueClass), b: b(String)]
        Value guarded in: MockClassMethodClass::bool
        At: #{class_method_position(MockClassMethodClass, :bool)}
    MES
  )
  end

  def test_array
    s = MockClassMethodClass
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
        Value guarded in: MockClassMethodClass::array
        At: #{class_method_position(MockClassMethodClass, :array)}
    MES
  )

    e2 = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.array([], b: 'b')
    end

    assert_equal(e2.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: b is expected (Array<Integer|String>) actual b(String)
        Expected: [a: (Array), b: (Array<Integer|String>)]
        Actual: [a: [](Array), b: b(String)]
        Value guarded in: MockClassMethodClass::array
        At: #{class_method_position(MockClassMethodClass, :array)}
    MES
  )

    e3 = assert_raises Moguro::Errors::ArgumentsTypeMismatchError do
      s.array([], b: [{}, 'b', 1])
    end

    assert_equal(e3.message, <<~"MES".chomp
      ArgumentsTypeError => Type MissMatch: b is expected (Array<Integer|String>) actual [{}, "b", 1](Array<Hash|String|Integer>)
        Expected: [a: (Array), b: (Array<Integer|String>)]
        Actual: [a: [](Array), b: [{}, "b", 1](Array<Hash|String|Integer>)]
        Value guarded in: MockClassMethodClass::array
        At: #{class_method_position(MockClassMethodClass, :array)}
    MES
  )
  end
end
