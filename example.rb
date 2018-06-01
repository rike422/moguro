require 'moguro'

class MockClass
  include Moguro::Decorator
  pre_c ->(a: Integer, b: String) {
    assert_equal(b, 'b')
  }

  # auto assign return value
  post_c -> (first: Integer) {
    p first
    assert_equal(first, 2)
  }

  def puts_method(a, b)
    puts b
    a + 1
  end

  post_c -> (first: String) {
    p first
  }
  def post_contract_violation_method
    1
  end
end

c = MockClass.new

c.puts_method(1, 'b')
# => 1
# => b

begin
  c.puts_method('a', 1)
rescue => e
  p e
end

# =>
# ArgumentsTypeError => Type MissMatch: a is expected (Integer) actual a(String) (Moguro::Errors::ArgumentsTypeMismatchError)
# Expected: [a: (Integer), b: (String)]
# Actual: [a: a(String), b: 1(Integer)]
# Value guarded in: MockClass::puts_method
# At: #{source_location}

begin
  c.puts_method(1, 'b')
rescue => e
  p e
end


begin
  c.post_contract_violation_method
rescue => e
  p e
end

begin
  c.puts_method(2, 'b')
rescue => e
  p e
end