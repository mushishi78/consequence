# This allows symbol#to_proc method to call private functions.
# Which can be useful if you want to have a class wrap itself in
# a Monad and call it private methods.

class Symbol
  def to_proc
    ->(v) { v.send(self) }
  end
end
