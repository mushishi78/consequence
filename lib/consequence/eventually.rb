require 'consequence/monad'

module Consequence
	class Eventually < Monad
		def initialize(proc)
			super(->(value){ proc.(value) })
		end

		def >>(proc)
			super(->(callback) { ->(value){ proc.(callback.(value)) } })
		end
	end
end
