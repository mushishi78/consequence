# Consequence

[![Build Status](https://travis-ci.org/mushishi78/consequence.svg?branch=master)](https://travis-ci.org/mushishi78/consequence)
[![Gem Version](https://badge.fury.io/rb/consequence.svg)](http://badge.fury.io/rb/consequence)

Simple monad implementation with clear and consistent syntax.

## Usage

A monad has a value that it is wrapped around. Its value can be anything: String, Module, Proc etc...
It takes its value as its only argument and can be initialized using the element reference syntax:

``` ruby
require 'consequence'
include Consequence

my_monad = Monad[4]
```

Its value can be retrieved with the `#value` getter method:

``` ruby
my_monad.value # 4
```

To create new monad types, simply inherit from `Monad`:

``` ruby
class Foo < Monad; end
class Bar < Monad; end
```

A monad is equal to another monad only if both it's type and value are equal:

``` ruby
Foo[0] == Foo[1] # false
Foo[0] == Bar[0] # false
Foo[0] == Foo[0] # true
```

A monad respond to query methods for all defined monads:

``` ruby
Foo[0].foo? # true
Foo[0].bar? # false
```

### Operations

Monads have two main operations `>>` and `<<`.

Both take an object with a `#call` method, such as a proc, for their only argument. The `#call` method can take 0-2 arguments and the monad will match them, even if it's a lamda or method object with arity checking.

It's first argument will be passed the monads value:

``` ruby
Foo[4] << ->(v) { puts v }
# $ 4
```

It's second argument will be passed the monad itself. This is useful for making decisions based on the monads type.

``` ruby
Foo[0] << ->(v, m) { puts v if m.foo? }
# $ 0
```

### `>>`

The `>>` operation may be variously thought of as the 'map', 'bind' or 'join' operations, but has been left unnamed to avoid any specific connotations.

It takes the result of the argument's `#call` method and passes it on:

``` ruby
Foo[0] >> ->(v) { Bar[v] } # Bar[0]
```

If the returned result that is not a monad, it is wrapped up in one so the chain can continue:

``` ruby
Foo[0] >> ->(v) { v + 1 } # Foo[1]
```

### `<<`

The `<<` operation may be thought of as the 'pipe' operation.

It calls the argument's `#call` method, but ignores the return value:

``` ruby
Foo[0] << ->(v) { v + 1 } # Foo[0]
```

This is useful for creating 'side effects', such as logging or assigning instance variables:

``` ruby
Foo[0] << ->(v) { @side_effect = v + 1 } # Foo[0]
puts @side_effect
# $ 1
```

## Built-In Types

### NullMonad

The `NullMonad` is a monad whose `>>` and `<<` operations have been overriden to ignore all input:

``` ruby
NullMonad[0] >> ->(v) { v + 1 } # Consequence::NullMonad[0]
```

This is different from the `<<` operation, because the argument's `#call` method isn't even run, so can cause no side effects:

``` ruby
NullMonad[0] << ->(v) { @side_effect = v + 1 }
puts @side_effect.inspect
# $ nil
```

For both operations, the `NullMonad` returns itself, so a chain of operations can be called on it without causing an error. This can be useful for stoping a chain midway through safely:

``` ruby
Continue = Class.new(Monad)
Stop = Class.new(NullMonad)

drop_first = ->(v) { v[1..-1] }
check_empty = ->(v, m) { v.empty? ? Stop[v] : m }

Continue[[1, 3, 4]] >> drop_first >> check_empty >> # Continue[[3, 4]]
                       drop_first >> check_empty >> # Continue[[4]]
                       drop_first >> check_empty >> # Stop[[]]
                       drop_first >> check_empty    # Stop[[]]
```

### Success & Failure

A `Success` monad wraps up all exceptions in a `Failure` monad:

``` ruby
Success[0] >> ->(v) { 5 / v }
# Consequence::Failure[#<ZeroDivisionError: divided by 0>]
```

A `Failure` monad is a subclass of the `NullMonad` so all successive chained operations are ignored.

For an example, check out the [Success & Failure example](https://github.com/mushishi78/consequence/wiki/Success-&-Failure-Example) on the wiki.

### Something & Nothing

A `Something` monad wraps up a nil result in a `Nothing` monad:

``` ruby
Something[[1, 3, 5]] >> ->(v) { v[4] } # Consequence::Nothing[nil]
```

A `Nothing` monad is also a subclass of the `NullMonad` so all successive chained operations are ignored. This prevents `MissingMethod` errors from trying to call a method on a `nil`.

A `Nothing` responds positively to the `#nil?` method:

``` ruby
Nothing[nil].nil? # true
```

### Eventually

The `Eventually` monad hooks up the callbacks of a chain of methods that may be executed some time in the future. This is useful for dealing with asynochronous calls.

For an example, check out the [Eventually example](https://github.com/mushishi78/consequence/wiki/Eventually-Example) on the wiki.

## DelegatesToValue

`DelegatesToValue` is a module that can be included into Monad that adds a `#method_missing` method to delegate calls to its value:

``` ruby
Foo.include DelegatesToValue
Foo[[1, 4, 6]].map {|n| n + 1} # Foo[[2, 5, 7]]
```

It delegates via the `>>` operation, so subclasses of the NullMonad will respond to delegated method calls, but still take no action:

``` ruby
dangrous_hash = {user: {orders: {1 => {price: 3.99} } } }

Something[dangrous_hash][:user][:orders][1][:price] # Consequence::Something[3.99]
Something[dangrous_hash][:user][:orders][2][:price] # Consequence::Nothing[nil]
```

## `#to_proc`

Before either operation calls the argument's `#call` method, the `#to_proc` method is called on it if it has one. This can be useful if the operation is given an object that has no `#call` method, but has a `#to_proc`.

A good example of this is the Symbol object, whose `#to_proc` method supplies a proc that sends the symbol as a message to its first argument. In this case this means calling that method on the value:

``` ruby
Foo[[1, 4, 7]] >> :pop # Foo[7]
```

## Wiki

To find some examples and information about utils, [check out the wiki](https://github.com/mushishi78/consequence/wiki) and feel free to contribute to it.

## Inspirations

* [Deterministic](https://github.com/pzol/deterministic)
* [Refactoring Ruby with Monads](https://www.youtube.com/watch?v=J1jYlPtkrqQ&feature=youtu.be&a)

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
