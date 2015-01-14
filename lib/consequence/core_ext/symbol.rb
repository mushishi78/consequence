# This allows symbol#to_proc method to call private functions.
# Which can be useful if you want to have a class wrap itself in
# a Monad, such as the Success/Failure example. Alternatively you
# can use Consequence::Utils#send_to_value.

class Symbol
	def to_proc
		->(v) { v.send(self) }
	end
end