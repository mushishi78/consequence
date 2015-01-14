require 'consequence/monad'

module Consequence
  class Something < Monad
    def >>(proc)
      result = super
      result.value.nil? ? Nothing[nil] : result
    end
  end

  class Nothing < NullMonad
    def nil?; true end
  end
end
