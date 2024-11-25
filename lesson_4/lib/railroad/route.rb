# frozen_string_literal: true

module Lesson4
  module Railroad
    # Represents a route between two or more stations.
    #
    # A route always starts and ends with two mandatory stations: the first and the last.
    # Additional stations can be added or removed, except for the first and last stations.
    #
    # This class operates on objects that respond to `#name`. The `#name` method should return
    # a value that can be converted to a string, but it is not strictly required to return a `String`.
    #
    # @example Creating a route
    #   first_station = OpenStruct.new(name: 'First')
    #   last_station = OpenStruct.new(name: 'Last')
    #   route = Lesson4::Railroad::Route.new(first_station, last_station)
    #
    # @example Adding and removing stations
    #   other_station = OpenStruct.new(name: 'Other')
    #   route.add(other_station)    # Adds an intermediate station
    #   route.remove(other_station) # Removes the intermediate station
    #
    class Route
      # Number of stations required to initialize a route.
      STATIONS_ON_START = 2

      # Error raised when the wrong number of stations is provided during initialization.
      class StationsNumberError < ::StandardError
        # Initializes the error message.
        #
        # @param number [Integer] The number of stations provided.
        def initialize(number)
          message_begin =
            case number
            when 0 then 'No stations'
            when 1 then 'Only one station'
            else "#{number} stations"
            end
          super "#{message_begin} given, must be only two!"
        end
      end

      # Initializes a new route with exactly two stations.
      #
      # @param list [Array<#name>] Two objects that respond to `#name`.
      # @raise [StationsNumberError] if the number of stations provided is not exactly two.
      def initialize(*list)
        raise StationsNumberError, list.size unless list.size == STATIONS_ON_START

        @list = list
      end

      # Returns the list of station names in the route.
      #
      # @return [Array<String>] A list of station names.
      def list = @list.map { _1.name.to_s }

      # Adds an intermediate station to the route.
      #
      # The station is added before the last station in the route.
      #
      # @param station [#name] An object that responds to `#name`.
      # @return [Array<#name>] The updated list of stations.
      def add(station) = @list.insert(-2, station)

      # Removes an intermediate station from the route.
      #
      # The first and last stations cannot be removed.
      #
      # @param station [#name] An object that responds to `#name`.
      # @return [#name, nil] The removed station, or `nil` if no station was removed.
      def remove(station)
        @list.delete(station) unless [@list.first, @list.last].include?(station)
      end
    end
  end
end
