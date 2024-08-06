# frozen_string_literal: true

module Lesson4
  module Railroad
    # Manages trains.
    class PassengerTrain < Train
      # @param number [String]
      # @param type [Symbol]
      # @param wagons [Integer]
      def initialize(number:)
        super(number:)

        @wagon_type = PassengerWagon
      end
    end
  end
end
