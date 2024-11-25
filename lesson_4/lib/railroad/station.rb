# frozen_string_literal: true

module Lesson4
  module Railroad
    # Represents a railway station that handles trains.
    #
    # A station has a name and manages a collection of trains currently present at the station.
    # It provides functionality to handle incoming trains, send trains away, and query trains by their wagon type.
    #
    # The station is designed to work with objects that respond to the `#wagon_type` method, which must return
    # a class that represents a type of wagon (e.g., `Lesson4::Railroad::Wagon` or its subclasses).
    #
    # @example Creating a station
    #   station = Lesson4::Railroad::Station.new('Central')
    #
    # @example Handling trains
    #   cargo_train = Lesson4::Railroad::CargoTrain.new(number: 'C123')
    #   passenger_train = Lesson4::Railroad::PassengerTrain.new(number: 'P456')
    #
    #   station.handle(cargo_train)
    #   station.handle(passenger_train)
    #
    #   station.trains # => [cargo_train, passenger_train]
    #   station.trains(Lesson4::Railroad::CargoWagon) # => [cargo_train]
    #
    # @example Sending a train
    #   station.send(cargo_train)
    #   station.trains # => [passenger_train]
    class Station
      # @return [String] the name of the station
      attr_reader :name

      # Initializes a new station with a name.
      #
      # @param name [String] the name of the station
      def initialize(name)
        @name = name
        @trains = []
      end

      # Returns all trains at the station, optionally filtered by wagon type.
      #
      # @param wagon_type [Class, nil] The class of the wagon type to filter by
      #   (e.g., `Lesson4::Railroad::CargoWagon` or `Lesson4::Railroad::PassengerWagon`).
      #   If `nil`, returns all trains.
      # @return [Array<#wagon_type>] An array of trains present at the station.
      def trains(wagon_type = nil) = wagon_type.nil? ? @trains : @trains.select { _1.wagon_type == wagon_type }

      # Handles an incoming train by adding it to the station's collection.
      #
      # @param train [#wagon_type] The train to handle.
      # @return [Array<#wagon_type>] The updated collection of trains at the station.
      def handle(train) = @trains << train

      # Sends a train away from the station.
      #
      # @param train [#wagon_type] The train to send.
      # @return [#wagon_type, nil] The removed train if it was at the station, or `nil` if not found.
      def send(train) = @trains.delete(train)
    end
  end
end
