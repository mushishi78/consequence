module Consequence
  class Failure < Monad
    def >>(_); self end
    def <<(_); self end
    def succeeded?; false end
    def failed?; true end
  end
end
