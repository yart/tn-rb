# frozen_string_literal: true

module Lesson4
  module Railroad
    # Manages trains.
    class CargoTrain < Train
      # @param number [String]
      def initialize(number:)
        super(number:)

        @wagon_type = CargoWagon
      end
    end
  end
end
