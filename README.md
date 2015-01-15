# Consequence

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

Its value can be retrieved with the `#value` getter method.

``` ruby
my_monad.value # 4
```

To create new monad types, simply inherit from `Monad`.

``` ruby
Foo = Class.new(Monad)
Bar = Class.new(Monad)
```

A monad is equal to another monad only if both it's type and value are equal.

``` ruby
Foo[0] == Foo[1] # false
Foo[0] == Bar[0] # false
Foo[0] == Foo[0] # true
```

### Operations

Monads have two main operations `>>` and `<<`.

Both take a proc for their only argument. The supplied proc can take 0-2 arguments and the monad will match them, even if it's a lamda or method object with arity checking.

It's first argument will be passed the monads value:

``` ruby
Foo[4] << ->(v) { puts v }
# $ 4
```

It's second argument will be passed the monad itself. This is useful for making decisions based on the monads type.

``` ruby
Foo[0] << ->(v, m) { puts v if m.is_a?(Foo) }
# $ 0
```

### `>>`

The `>>` operation may be variously thought of as the 'map', 'bind' or 'join' operations, but has been left unnamed to avoid any specific connotations.

It takes the result of the proc given to it and passes it on:

``` ruby
Foo[0] >> ->(v) { Bar[v] } # Bar[0]
```

If it return's a result that is not a monad, it is wrapped up in one so the chain can continue:

``` ruby
Foo[0] >> ->(v) { v + 1 } # Foo[1]
```

### `<<`

The `<<` operation may be thought of as the 'pipe' operation.

It calls the proc given to it, but ignores it's return value:

``` ruby
Foo[0] << ->(v) { v + 1 } # Foo[0]
```

This is useful for creating 'side effects', such as logging or assigning instance variables:

``` ruby
Foo[0] << ->(v) { @side_effect = v + 1 } # Foo[0]
puts @side_effect
# $ 1
```

### `#to_proc`

Before either operation calls a proc, the `#to_proc` method is called on it. This can be useful if the operation is given an object that is no a proc, but has a `#to_proc` method that returns one.

A good example of this is the Symbol object, whose `#to_proc` method supplies a proc that sends the symbol as a message to its first argument. In this case this means calling that method on the value:

``` ruby
Foo[[1, 4, 7]] >> :pop # Foo[7]
```

This also can be used to make a composition syntax, by writing a `#to_proc` method for a monad:

``` ruby
class Add < Monad
  def to_proc
    ->(v) { v + value }
  end
end

Add[1] >> Add[4] >> Add[6] # Add[11]
```

## Built-In Types

### `NullMonad`

The `NullMonad` is a monad whose `>>` and `<<` operations have been overriden to ignore all input:

``` ruby
NullMonad[0] >> ->(v) { v + 1 } # Consequence::NullMonad[0]
```

This is different from the `<<` operation, because the proc isn't even run, so can cause no side effects:

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

A `Failure` monad is a subclass of the `NullMonad` so all successive chained procs are ignored.

Both `Success` and `Failure` respond to the `#succeeded?` and `#failed?` query methods in the way you'd expect:

``` ruby
Success[0].succeeded? # true
Success[0].failed? # false
Failure[0].succeeded? # false
Failure[0].failed? # true
```

### Something & Nothing

A `Something` monad wraps up a nil result in a `Nothing` monad:

``` ruby
Something[[1, 3, 5]] >> ->(v) { v[4] } # Consequence::Nothing[nil]
```

A `Nothing` monad is also a subclass of the `NullMonad` so all successive chained procs are ignored. This prevents `MissingMethod` errors from trying to call a method on a `nil`.

A `Nothing` responds positively to the `#nil?` method:

``` ruby
Nothing[nil].nil? # true
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
