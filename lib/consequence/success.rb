require 'consequence/monad'

module Consequence
  class Success < Monad
    def >>(obj)
      super
    rescue => err
      Failure[err]
    end

    def <<(obj)
      super
    rescue => err
      Failure[err]
    end
  end

  class Failure < NullMonad; end
end
