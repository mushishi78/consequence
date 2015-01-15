# Consequence

[![Gem Version](https://badge.fury.io/rb/consequence.svg)](http://badge.fury.io/rb/consequence)

Simple monad implementation with clear and consistent syntax.

## Usage

``` ruby
require 'consequence'

def process(i)
  Foo[i] >> :next << log >> validate
end

def log
  ->(v) { puts v }
end

def validate
  ->(v, m) { m == Foo[5] ? m : Bar['Fail'] }
end

Foo = Class.new(Consequence::Monad)
Bar = Class.new(Consequence::Monad)

p process(0) # Bar['Fail']
p process(4) # Foo[5]
```

## Operations

<dl>
  <dt> &gt;&gt; Right Shift </dt>
  <dd>Chains a proc with the result being passed along. If the result is not a monad, it is wrapped up in one.</dd>

  <dt> &lt;&lt; Left Shift </dt>
  <dd>The supplied proc is applied with the result being ignored and the unchanged monad is passed down the chain.</dd>
</dl>

If the proc accepts one argument, it is passed only the `value` of the monad. If it accepts two arguments, it is passed both the `value` and the monad.

Before being called, the proc have their `#to_proc` method called. This allows a `Symbol` to be passed in, whose `#to_proc` method sends the symbol as a message to the `value` of the monad.

## Types

### Success & Failure

A `Success` monad wraps up all exceptions in a `Failed` monad and a `Failed` monad ignores all chained methods. This allows all possible failures in a long process to be dealt with at the end.

``` ruby
require 'consequence'

module CreateUser
  class << self
    include Consequence
    alias_method :m, :method

    def create(attributes)
      Success[attributes] >> m(:build) >> m(:validate) >> m(:persist)
    end

    private

    def build(attributes)
      User.new(attributes)
    end

    def validate(user)
      validator = UserValidator.new(user)
      validator.valid? ? Success[user] : Failure[validator.errors]
    end

    def persist(user)
      user.save
    end
  end
end
```

If the `User#new` raises an exception, the `validate` and `persist` methods won't be called, and a `Failure` monad will be returned with the exception as it's `value`.

If the `validator` finds the new user to be invalid, the `persist` method will not be called and a `Failure` monad will be returned with the errors as it's `value`.

### Something & Nothing

A `Something` monad wraps up a nil result in a `Nothing` monad and a `Nothing` monad ignores all chained methods. This prevents `MissingMethod` errors from trying to be call a method on `nil`.

## Utils

### `send_to_value` and `send_to_monad`

`send_to_value` and `send_to_monad` are utility methods that can be included from `Consequence::Utils`. They create procs that pass their arguments to the send method on the value and monad respectively.

``` ruby
include Consequence::Utils

Monad[2] << send_to_value(:**, 3) # Monad[8]
```

To include into Object to be available within all objects:

``` ruby
require 'consequence/core_ext/utils'
```

### `Object#m`

As a shorthand for the `Object#method` method, it can be useful to alias this to `m`, such as in the Success/Failure example. To do this for all objects:

``` ruby
require 'consequence/core_ext/m_alias'
```

### `Symbol#to_proc`

`Symbol#to_proc` can't be used to call private methods. This is inconvenient if you want an object to wrap itself up and call it's own private methods with symbols. To use that style of notation, you can add this:

``` ruby
require 'consequence/core_ext/private_symbol_proc'
```

## Composition

To write composition methods, it is possible to write `#to_proc` method for a monad like so:

``` ruby
class Partial < Consequence::Monad
  def initialize(value)
    value.is_a?(Proc) ? super(value.curry) : super
  end

  def to_proc
    ->(fn) { fn.(value) }
  end
end

m = ->(x, y, z) {x + y + z}

Partial[m] >> Partial[1] >> Partial[4] >> Partial[9] # Partial[14]
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'consequence'
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/consequence/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
