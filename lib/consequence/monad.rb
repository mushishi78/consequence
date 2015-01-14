module Consequence
  class Monad
    def self.[](value)
      new(value)
    end

    def initialize(value)
      @value = value
    end

    attr_reader :value

    def >>(proc)
      wrap(bind(proc.to_proc))
    end

    def <<(proc)
      bind(proc.to_proc)
      self
    end

    def ==(other)
      self.class == other.class && value == other.value
    end

    def to_s
      value.to_s
    end

    def inspect
      "#{self.class}[#{value.inspect}]"
    end

    private

    def bind(proc)
      proc.call(*args_for(proc))
    end

    def args_for(proc)
      [value, self][0, proc.arity.abs]
    end

    def wrap(value)
      value.is_a?(Monad) ? value : self.class[value]
    end
  end

  class NullMonad < Monad
    def >>(_); self end
    def <<(_); self end
  end
end
