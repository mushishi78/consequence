require 'consequence/monad'
require 'consequence/delegates_to_value'

module Consequence
  class Something < Monad
    include DelegatesToValue

    def >>(proc)
      result = super
      result.value.nil? ? Nothing[nil] : result
    end
  end

  class Nothing < NullMonad
    include DelegatesToValue

    def nil?; true end
  end
end
