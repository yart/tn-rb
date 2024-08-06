# frozen_string_literal: true

require_relative 'railroad/station'
require_relative 'railroad/route'
require_relative 'railroad/train'

module Lesson3
  # Manages railroad stations. trains and so on.
  module Railroad
    CARGO     = :cargo
    PASSENGER = :passenger
  end
end
