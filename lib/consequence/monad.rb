module Consequence
  class Monad
    include Contracts

    def self.[](value)
      new(value)
    end

    def initialize(value)
      @value = value
    end

    attr_reader :value

    # >>
    #########
    Contract Symbol => Monad
    define_method(:>>) { |symbol| wrap(vbind(symbol.to_proc)) }

    Contract Func[Not[Monad] => Not[Monad]] => Monad
    define_method(:>>) { |proc| wrap(vbind(proc)) }

    Contract Func[Not[Monad] => Monad] => Monad
    define_method(:>>) { |proc| vbind(proc) }

    Contract Func[Monad => Monad] => Monad
    define_method(:>>) { |proc| bind(proc) }

    Contract Func[Monad => Not[Monad]] => Monad
    define_method(:>>) { |proc| wrap(bind(proc)) }

    # <<
    #########
    Contract Symbol => Monad
    define_method(:<<) { |symbol| vbind(symbol.to_proc); self }

    Contract Func[Not[Monad] => Any] => Monad
    define_method(:<<) { |proc| vbind(proc); self }

    Contract Func[Monad => Any] => Monad
    define_method(:<<) { |proc| bind(proc); self }

    def ==(other)
      self.class == other.class && value == other.value
    end

    def to_s
      "#{self.class}[#{value}]"
    end

    def inspect
        to_s
    end

    private

    def bind(proc)
      proc.call(self)
    end

    def vbind(proc)
      proc.call(value)
    end

    def wrap(value)
      self.class[value]
    end
  end
end
