require 'contracts'

module Consequence
  def self.included(base)
    base.include(Contracts)
  end
end

require 'consequence/monad'
require 'consequence/failure'
require 'consequence/success'
require 'consequence/option'
