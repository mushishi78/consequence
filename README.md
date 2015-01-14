# Consequence

[![Gem Version](https://badge.fury.io/rb/consequence.svg)](http://badge.fury.io/rb/consequence)

Monad implementation to be used with [contracts.ruby](https://github.com/egonSchiele/contracts.ruby)

## Example Usage

``` ruby
require 'consequence'

class HirePirate
  include Consequence
  alias_method :m, :method

  def apply(applicant)
    Success[applicant] >> m(:eye_patch_check) << m(:log) >> :sign_and_date
  end

  private

  Contract Applicant => Monad
  def eye_patch_check(applicant)
    applicant.working_eyes > 1 ? Failure['Too many eyes'] : Success[Pirate.new(applicant)]
  end

  def log(pirate)
    puts "#{pirate.name} has joined the crew"
  end
end
```

## Monad Methods

### >>

Chains a method with the result being passed down the chain.

If the method has a contract that requires a Monad, then the method is passed the Monad, otherwise it is passed it's value.

If the method has a contract that returns a Monad, then that Monad is passed down the chain, otherwise the result of the method is taken as the value for a new Monad.

If called with a Symbol instead of a method, it is sent as a message to the value, and the result is taken as the value for a new Monad.

### <<

Method is applied with the result being ignored and the unchanged Monad is passed down the chain.

If the method has a contract that requires a Monad, then the method is passed the Monad, otherwise it is passed it's value.

If called with a Symbol instead of a method, it is sent as a message to the value.

## Monad Types

### Success & Failure

A Success Monad wraps up all exceptions in a Failed Monad and a Failed Monad ignores all chained methods. This allows all possible failures in a long process to be dealt with at the end.

### Option

A Option Monad only applies a method if it's value is not nil, otherwise it ignores them. This prevents MissingMethod errors from methods trying to be applied to nil.

## Example Implementation of Left and Right

``` ruby
require 'consequence'
include Consequence

class Left < Monad
  def <<(proc)
    super >> :next
  end
end

class Right < Monad
  def <<(proc)
    super >> :chop
  end
end

class LetterChopper
  alias_method :m, :method

  Contract Monad => Monad
  def begin(monad = Left['|-|*|-|*|-|'])
    monad >> m(:pick) << m(:log) >> m(:continue?)
  end

  private

  Contract String => Monad
  def pick(value)
    rand > 0.1 ? Left[value] : Right[value]
  end

  def log(value)
    puts value
  end

  Contract Monad => Monad
  def continue?(monad)
    monad.value.empty? ? monad : monad >> m(:begin)
  end
end

LetterChopper.new.begin
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
