require 'consequence/monad'

module Consequence
  class Eventually < Monad
    def initialize(value)
      super(promise(value))
    end

    def execute
      value.call(->(v) { v })
    end

    def >>(proc)
      super(promise(proc))
    end

    def <<(proc)
      super(promise(proc))
    end

    private

    def promise(proc)
      ->(callback){ callback.(proc) }
    end
  end
end
