class MockPreConditionClass
  include Moguro::Decorator

  pre_c ->(a: String, b: String) {
    assert_equal(a, a)
    puts "#{a} and #{b}"
  }

  def plain(a, b)
    puts "#{a} + 1 and #{b} + 1"
  end

  pre_c ->(a: Integer, b: Integer) {
    assert_equal(a, a)
    puts "#{a} and #{b}"
  }

  def opt(a = 1, b = 2)
    puts "#{a} + 1 and #{b} + 1"
  end

  pre_c ->(a: Integer, b: Integer, c:) {
    puts "#{a} and #{b} and #{c}"
  }

  def kwd(a:, b: 2, c: 3)
    puts "#{a} + 1 and #{b} + 1 and #{c} + 1"
  end

  pre_c ->(a: Integer, b: Integer, c: Integer) {
    puts "#{a} and #{b} and #{c}"
  }

  def mix(a, b = 1, c: 2)
    puts "#{a} + 1 and #{b} + 1 and #{c} + 1"
  end

  pre_c ->(a: Integer || nil, b: Integer || nil, c: String || nil) {
    puts "#{a} and #{b} and #{c}"
  }

  def nullable(a, b = 1, c: 2)
    puts "#{a} + 1 and #{b} + 1 and #{c} + 1"
  end

  pre_c ->(a: Boolean, b: Boolean) {
    puts "#{a} and #{b}"
  }

  def bool(a, b: false)
    puts "#{b} and #{a}"
  end

  pre_c ->(a: Array, b: Array[Integer, String]) {
    puts "#{a.join(',')}/#{b.join(',')}"
  }

  def array(a, b: [])
    puts "#{a.join(',')}+#{b.join(',')}"
  end
end

class MockClassMethodClass
  include Moguro::Decorator

  pre_c ->(a: String, b: String) {
    assert_equal(a, a)
    puts "#{a} and #{b}"
  }

  def self.plain(a, b)
    puts "#{a} + 1 and #{b} + 1"
  end

  pre_c ->(a: Integer, b: Integer) {
    assert_equal(a, a)
    puts "#{a} and #{b}"
  }

  def self.opt(a = 1, b = 2)
    puts "#{a} + 1 and #{b} + 1"
  end

  pre_c ->(a: Integer, b: Integer, c:) {
    puts "#{a} and #{b} and #{c}"
  }

  def self.kwd(a:, b: 2, c: 3)
    puts "#{a} + 1 and #{b} + 1 and #{c} + 1"
  end

  pre_c ->(a: Integer, b: Integer, c: Integer) {
    puts "#{a} and #{b} and #{c}"
  }

  def self.mix(a, b = 1, c: 2)
    puts "#{a} + 1 and #{b} + 1 and #{c} + 1"
  end

  pre_c ->(a: Integer || nil, b: Integer || nil, c: String || nil) {
    puts "#{a} and #{b} and #{c}"
  }

  def self.nullable(a, b = 1, c: 2)
    puts "#{a} + 1 and #{b} + 1 and #{c} + 1"
  end

  pre_c ->(a: Boolean, b: Boolean) {
    puts "#{a} and #{b}"
  }

  def self.bool(a, b: false)
    puts "#{b} and #{a}"
  end

  pre_c ->(a: Array, b: Array[Integer, String]) {
    puts "#{a.join(',')}/#{b.join(',')}"
  }

  def self.array(a, b: [])
    puts "#{a.join(',')}+#{b.join(',')}"
  end
end


class MockPostConditionClass
  include Moguro::Decorator

  post_c ->(a: String) {
    assert_equal(a, a)
    puts "post: #{a}"
  }

  def one(a)
    puts a
    a
  end

  post_c ->(a: String, b: String) {
    assert_equal(a, a)
    puts "post: #{a} and #{b}"
  }

  def two(a, b)
    puts "#{a} and #{b}"
    return a, b
  end

  post_c ->(a: Boolean, b: Boolean) {
    puts "post: #{a} and #{b}"
  }

  def bool(a, b: false)
    puts "#{a} and #{b}"
    return a, b
  end

  post_c ->(a: Array, b: Array[Integer, String]) {
    puts "post: #{a}/#{b}"
  }

  def array(a, b: [])
    puts "#{a}/#{b}"
    return a, b
  end
end

class MockClassMethodPostConditionClass
  include Moguro::Decorator

  post_c ->(a: String) {
    assert_equal(a, a)
    puts "post: #{a}"
  }

  def self.one(a)
    puts a
    a
  end

  post_c ->(a: String, b: String) {
    assert_equal(a, a)
    puts "post: #{a} and #{b}"
  }

  def self.two(a, b)
    puts "#{a} and #{b}"
    return a, b
  end

  post_c ->(a: Boolean, b: Boolean) {
    puts "post: #{a} and #{b}"
  }

  def self.bool(a, b: false)
    puts "#{a} and #{b}"
    return a, b
  end

  post_c ->(a: Array, b: Array[Integer, String]) {
    puts "post: #{a}/#{b}"
  }

  def self.array(a, b: [])
    puts "#{a}/#{b}"
    return a, b
  end
end