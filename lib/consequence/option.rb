module Consequence
  class Option < Monad
    def >>(proc)
      value ? super : self
    end

    def <<(proc)
      super if value
    end

    def nil?; value.nil? end
  end
end
