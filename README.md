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

# `>>` Right Shift

Chains a proc with the result being passed along. If the result is not a monad, it is wrapped up in one.

# `<<` Left Shift

The supplied proc is applied with the result being ignored and the unchanged monad is passed down the chain.

---

If the proc accepts one argument, it is passed only the `value` of the monad. If it accepts two values, it is passed both the `value` and the monad.

Before being called, the proc have their `#to_proc` method called. This allows a `Symbol` to be passed in, whose `#to_proc` method sends the symbol as a message to the `value` of the monad.

## Types

# Success & Failure

A `Success` monad wraps up all exceptions in a `Failed` monad and a `Failed` monad ignores all chained methods. This allows all possible failures in a long process to be dealt with at the end.

``` ruby
require 'consequence'
require 'consequence/core_ext/symbol'

class CreateUser
  include Consequence

  def create(attributes)
    @attributes = attributes
    Success[self] << :build >> :validate >> :persist
  end

  private

  def build
    @user = User.new(@attributes)
  end

  def validate
    validator = UserValidator.new(@user)
    validator.valid? ? Success[self] : Failure[validator.errors]
  end

  def persist
    @user.save
  end
end
```

If the `User#new` raises an exception, the `validate` and `persist` methods won't be called, and a `Failure` monad will be returned with the exception as it's `value`.

If the `validator` finds the new user to be invalid, the `persist` method will not be called and a `Failure` monad will be returned with the errors as it's `value`.

# Something & Nothing

A `Something` monad wraps up a nil result in a `Nothing` monad and a `Nothing` monad ignores all chained methods. This prevents `MissingMethod` errors from trying to be call a method on `nil`.

---

## Utils

`send_to_value` and `send_to_monad` are utility methods that can be included from `Consequence::Utils`. They create procs that pass their arguments to the send method on the value and monad respectively.

``` ruby
include Consequence::Utils

Monad[2] << send_to_value(:**, 3) # Monad[8]
```

To include into Object to be available within all objects:

``` ruby
require 'consequence/core_ext/utils'
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
