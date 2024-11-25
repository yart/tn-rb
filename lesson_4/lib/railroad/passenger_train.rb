# frozen_string_literal: true

module Lesson4
  module Railroad
    # Represents a passenger train.
    #
    # This class specializes `Lesson4::Railroad::Train` for managing passenger trains.
    # It sets the wagon type to `Lesson4::Railroad::PassengerWagon` by default.
    #
    # @example Creating a passenger train
    #   passenger_train = Lesson4::Railroad::PassengerTrain.new(number: 'P456')
    #
    # @example Attaching a wagon
    #   wagon = Lesson4::Railroad::PassengerWagon.new
    #   passenger_train.attach(wagon)
    #
    # @example Moving along a route
    #   passenger_train.route = some_route
    #   passenger_train.backward
    #   passenger_train.location(:previous) # => previous station on the route
    class PassengerTrain < Train
      # Initializes a passenger train.
      #
      # @param number [String] The unique identifier for the train.
      def initialize(number:)
        super(number:)

        @wagon_type = PassengerWagon
      end
    end
  end
end
