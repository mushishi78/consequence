module Consequence
  class Success < Monad
    def >>(proc)
      super
    rescue => err
      Failure[err]
    end

    def <<(proc)
      super
    rescue => err
      Failure[err]
    end

    def succeeded?; true end
    def failed?; false end
  end

  class Failure < NullMonad
    def succeeded?; false end
    def failed?; true end
  end
end
