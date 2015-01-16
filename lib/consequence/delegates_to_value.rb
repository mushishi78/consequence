require 'consequence/monad'

module Consequence
  module DelegatesToValue
    def method_missing(method_name, *args, &b)
      return super unless value.respond_to?(method_name)
      self >> -> { value.send(method_name, *args, &b) }
    end

    protected

    def respond_to_missing?(method_name, include_private = false)
      value.respond_to?(method_name, include_private) || super
    end
  end
end
