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
end
