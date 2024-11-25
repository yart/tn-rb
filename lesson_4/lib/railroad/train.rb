# frozen_string_literal: true

module Lesson4
  module Railroad
    # Represents a train in the railroad system.
    #
    # A train has a unique number, wagons, and a route. It manages its movement
    # along the route and allows attaching or detaching compatible wagons.
    class Train
      attr_accessor :speed
      attr_reader :number, :wagon_type, :wagons, :default_speed

      # Initializes a new train with a number and default attributes.
      #
      # @param number [String] The unique identifier for the train.
      def initialize(number:)
        @number   = number
        @wagons   = []
        @speed    = 0
        @route    = []
        @location = { current: nil, previous: nil, next: nil }

        @wagon_type    = Wagon
        @default_speed = 100
      end

      # Attaches a wagon to the train if it is compatible and the train is stopped.
      #
      # @param wagon [#compatible_with?] The wagon to attach. It must respond to the `#compatible_with?` method.
      # @return [Array<#compatible_with?>, nil] The updated list of wagons if the wagon was attached, or `nil` if not attached.
      def attach(wagon)
        return unless wagon.compatible_with?(self)

        @wagons << wagon if can_attach?
      end

      # Detaches the last wagon from the train if the train is stopped and has wagons.
      #
      # @return [#compatible_with?, nil] The detached wagon, or `nil` if no wagon was detached.
      def detach
        @wagons.pop if can_detach?
      end

      # Stops the train by setting its speed to zero.
      #
      # @return [Integer] The speed after stopping, which will always be zero.
      def stop = @speed = 0

      # Sets the route for the train and initializes its location.
      #
      # @param route [#list] The route to assign to the train.
      # @return [#list] The assigned route.
      def route=(route)
        @location[:current] = 0
        @location[:next]    = 1

        @route = route
      end

      # Returns the train's location on its route.
      #
      # If `kind` is provided, returns the station corresponding to `:previous`, `:current`, or `:next`.
      #
      # @param kind [Symbol, nil] The location type to query (`:previous`, `:current`, or `:next`).
      # @return [Hash<Symbol, String>, String, nil] A hash of locations, or a specific station if `kind` is provided.
      def location(kind = nil)
        locations = {
          previous: @location[:previous] ? @route.list[@location[:previous]] : nil,
          current:  @route.list[@location[:current]],
          next:     @location[:next] ? @route.list[@location[:next]] : nil
        }

        return locations[kind] if kind

        locations
      end

      # Moves the train backward along the route.
      #
      # @return [void]
      def backward = go(:backward)

      # Moves the train forward along the route.
      #
      # @return [void]
      def forward = go(:forward)

      private

      # Moves the train in the specified direction, updating its speed and location.
      #
      # @param direction [Symbol] The direction to move (:forward or :backward).
      # @return [void]
      def go(direction)
        @direction = direction
        @speed     = default_speed

        fetch_current_location
        fetch_previous_location
        fetch_next_location
      end

      # Checks if a wagon can be attached to the train.
      #
      # @return [Boolean] `true` if the train is stopped, otherwise `false`.
      def can_attach? = speed.zero?

      # Checks if a wagon can be detached from the train.
      #
      # @return [Boolean] `true` if the train is stopped and has wagons, otherwise `false`.
      def can_detach? = speed.zero? && !@wagons.empty?

      # Returns the movement step based on the current direction.
      #
      # @return [Integer] `1` for forward, `-1` for backward.
      def move = { forward: 1, backward: -1 }[@direction]

      # Checks if the train can move in the current direction.
      #
      # @return [Boolean] `true` if movement is possible, otherwise `false`.
      def can_move?
        {
          forward:  @location[:current] < @route.list.size - 1,
          backward: !@location[:current].zero?
        }[@direction]
      end

      # Updates the current location of the train.
      #
      # @return [void]
      def fetch_current_location
        @location[:current] += move if can_move?
      end

      # Updates the previous location of the train.
      #
      # @return [void]
      def fetch_previous_location = @location[:previous] = can_move? ? @location[:current] - 1 : nil

      # Updates the next location of the train.
      #
      # @return [void]
      def fetch_next_location = @location[:next] = can_move? ? @location[:current] + 1 : nil
    end
  end
end
