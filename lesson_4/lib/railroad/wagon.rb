# frozen_string_literal: true

module Lesson4
  module Railroad
    # Represents a general wagon.
    #
    # This is the base class for all types of wagons.
    class Wagon
      # Checks if the wagon is compatible with a given train.
      #
      # By default, compatibility is determined by comparing the train's wagon type with the class of this wagon.
      #
      # @param train [#wagon_type] The train to check compatibility with.
      # @return [Boolean] true if the wagon is compatible with the train, false otherwise.
      def compatible_with?(train)
        train.wagon_type == self.class
      end
    end
  end
end
