class Foo < Consequence::Monad; end
class Bar < Consequence::Monad; end

class Methods
  include Consequence
  attr_accessor :side_effect

  Contract Monad => Monad
  def compare(m)
    m == Foo[0] ? Foo[1] : Bar[0]
  end

  Contract Monad => Num
  def transform(m)
    m == Foo[0] ? 10 : 3
  end

  Contract Num => Monad
  def validate(v)
    v > 0 ? Foo[v] : Bar[v]
  end

  def increment(v)
    v + 1
  end

  def log(v)
    @side_effect = v
  end

  Contract Foo => Num
  def react(m)
    @side_effect = m.value
  end

  Contract Bar => String
  def react(m)
    @side_effect =  "Bar! #{m.value}"
  end

  def dangerous(v)
    return v + 5 unless v > 2
    fail ArgumentError
  end
end
