# Consequence

[![Gem Version](https://badge.fury.io/rb/consequence.svg)](http://badge.fury.io/rb/consequence)

Simple monad implementation with clear and consistent syntax.

## Usage

``` ruby
require 'consequence'

Foo = Class.new(Consequence::Monad)
Bar = Class.new(Consequence::Monad)

compare   = ->(v, m) { m == Foo[0] ? Foo[1] : Bar[v] }
transform = ->(v, m) { m == Foo[1] ? 10 : 3 }
validate  = ->(v) { v > 4 ? Bar[v] : Foo[v] }
increment = ->(v) { v + 1 }

react = ->(v, m) { @side_effect = v ** 2 if m.is_a?(Bar) }
log   = ->(v) { @side_effect = @side_effect.to_s }

result = Foo[0] >>
         compare >>   # Foo[1]
         transform >> # Foo[10]
         validate >>  # Bar[10]
         increment >> # Bar[11]
         :next << react << log

p result        # Bar[12]
p @side_effect  # "144"
```

## Operations

* `>>` - Chains a proc with the result being passed along. If the result is not a `Monad`, it is wrapped up in one.

* `<<` - The supplied proc is applied with the result being ignored and the unchanged `Monad` is passed down the chain.

If the proc accepts one argument, it is passed only the `value` of the `Monad`. If it accepts two values, it is passed both the `value` and the `Monad`.

Before being called, the proc have their `#to_proc` method called. This allows a `Symbol` to be passed in, whose `#to_proc` method sends the symbol as a message to the `value` of the `Monad`.

## Types

### Success & Failure

A `Success` monad wraps up all exceptions in a `Failed` monad and a `Failed` monad ignores all chained methods. This allows all possible failures in a long process to be dealt with at the end.

### Something & Nothing

A `Something` monad wraps up a nil result in a `Nothing` monad and a `Nothing` monad ignores all chained methods. This prevents `MissingMethod` errors from trying to be call a method on `nil`.

## Utils

`send_to_value` and `send_to_monad` are utility methods that can be included from `Consequence::Utils`. They create procs that pass their arguments to the send method on the value and monad respectively.

``` ruby
include Consequence::Utils

Monad[2] << send_to_value(:**, 3) # Monad[8]
```

To include into Object to be available within all objects:

``` ruby
require 'consequence/core_ext'
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
