module Consequence
	module Utils
		def send_to_value(*args)
			->(v) { v.send(*args) }
		end

		def send_to_monad(*args)
			->(v, m) { m.send(*args) }
		end
	end
end