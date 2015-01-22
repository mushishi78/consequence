require 'inflecto'

module Consequence
  class Monad
    class << self
      def [](value)
        new(value)
      end

      def inherited(child)
        return unless child.name
        query_name = Inflecto.demodulize(child.name)
        query_name = Inflecto.underscore(query_name)
        query_name = "#{query_name}?".to_sym
        define_method(query_name) { self.is_a?(child) }
      end
    end

    def initialize(value)
      @value = value
    end

    attr_reader :value

    def >>(obj)
      obj = obj.to_proc if obj.respond_to?(:to_proc)
      wrap(bind(obj))
    end

    def <<(obj)
      bind(obj.to_proc)
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

    def bind(obj)
      obj.call(*args_for(obj))
    end

    def args_for(obj)
      [value, self][0, arity(obj)]
    end

    def arity(obj)
      method = obj.respond_to?(:arity) ? obj : obj.method(:call)
      method.arity.abs
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
