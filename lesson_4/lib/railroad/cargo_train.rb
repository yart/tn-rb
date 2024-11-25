# frozen_string_literal: true

module Lesson4
  module Railroad
    # Represents a cargo train.
    #
    # This class specializes `Lesson4::Railroad::Train` for managing cargo trains.
    # It sets the wagon type to `Lesson4::Railroad::CargoWagon` by default.
    #
    # @example Creating a cargo train
    #   cargo_train = Lesson4::Railroad::CargoTrain.new(number: 'C123')
    #
    # @example Attaching a wagon
    #   wagon = Lesson4::Railroad::CargoWagon.new
    #   cargo_train.attach(wagon)
    #
    # @example Moving along a route
    #   cargo_train.route = some_route
    #   cargo_train.forward
    #   cargo_train.location(:current) # => current station on the route
    class CargoTrain < Train
      # Initializes a cargo train.
      #
      # @param number [String] The unique identifier for the train.
      def initialize(number:)
        super(number:)

        @wagon_type = CargoWagon
      end
    end
  end
end
