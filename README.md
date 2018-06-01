# Moguro  [![Gem Version](https://badge.fury.io/rb/moguro.svg)](https://badge.fury.io/rb/moguro) [![Build Status](https://travis-ci.org/rike422/moguro.svg?branch=master)](https://travis-ci.org/rike422/moguro)  [![Code Climate](https://codeclimate.com/github/rike422/moguro/badges/gpa.svg)](https://codeclimate.com/github/rike422/moguro) [![Coverage Status](https://coveralls.io/repos/github/rike422/moguro/badge.svg?branch=master)](https://coveralls.io/github/rike422/moguro?branch=master)
                   

Decorator style assertions and type check library for Contract programming

This gem is still in development and it isnt available to production.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'moguro'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install moguro

## Usage

```ruby
require 'moguro'

class MockClass
  include Moguro::Decorator
  
  # Must match argument names of decorate method
  pre_c ->(a: Integer, b: String) {
    assert_equal(a, 1)
    assert_equal(b, 'b')
  }
 
  def puts_method(a, b)
    puts b
    a + 1
  end
  
  # Return values are auto assigned in order
  post_c -> (first: String) {
    p first
  }
  def post_contract_violation_method
    1
  end
  
end

c = MockClass.new
c.puts_method(1, 'b')
# 1
# => 2

begin 
  c.puts_method('a', 1)
rescue => e
  p e
end
# =>
# Type MissMatch: a is expected (Integer) actual a(String) (Moguro::Errors::ArgumentsTypeMismatchError)
# Expected: [a: (Integer), b: (String)]
# Actual: [a: a(String), b: 1(Integer)]
# Value guarded in: MockClass::puts_method
# At: #{source_location}

begin
  c.post_contract_violation_method
rescue => e
  p e
end

# =>
# Type MissMatch: first is expected (String) actual 1(Integer)
#  Expected: [first: (String)]
#  Actual: [first: 1(Integer)]
#  Value guarded in: MockClass::post_contract_violation_method
#  At: #{source_location}

```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Moguro project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/moguro/blob/master/CODE_OF_CONDUCT.md).
