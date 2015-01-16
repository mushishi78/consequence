require 'consequence/monad'

module Consequence
	class Eventually < Monad
	  def execute(proc)
	    value.(proc)
	  end

	  def <<(_); self end

	  private

	  def bind(proc)
	    ->(callback) { execute(proc.(callback)) }
	  end
	end
end
