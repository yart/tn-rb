# frozen_string_literal: true

module Lesson3
  module Railroad
    # Manages trains.
    class Train
      BACKWARD = :backward
      FORWARD  = :forward

      DEFAULT_SPEED = 100

      attr_accessor :speed
      attr_reader :number, :type, :wagons

      # @param number [String]
      # @param type [Symbol]
      # @param wagons [Integer]
      def initialize(number:, type:, wagons:)
        @number   = number
        @type     = type
        @wagons   = wagons
        @speed    = 0
        @route    = []
        @location = { current: nil, previous: nil, next: nil }
      end

      # @return [Integer]
      def attach
        @wagons += 1 if can_attach?
      end

      # @return [Integer, nil]
      def detach
        @wagons -= 1 if can_detach?
      end

      # @return [Integer]
      def stop = @speed = 0

      # @param route [Railroad::Route]
      # @return [Railroad::Route]
      def route=(route)
        @location[:current] = 0
        @location[:next]    = 1

        @route = route
      end

      # @param kind [Symbol]
      # @return [Hash, Railroad::Station, nil]
      def location(kind = nil)
        if kind.nil?
          return {
            previous: @route.list[@location[:previous]],
            current: @route.list[@location[:current]],
            next: @route.list[@location[:next]]
          }
        end

        @route.list[@location[kind]] unless @location[kind].nil?
      end

      # @param direction [Symbol]
      def go(direction)
        @direction = direction
        @speed     = DEFAULT_SPEED

        fetch_current_location
        fetch_previous_location
        fetch_next_location
      end

      private

      def can_attach? = speed.zero?
      def can_detach? = speed.zero? && !@wagons.zero?

      def move      = { FORWARD => 1, BACKWARD => -1 }
      def can_move? = { FORWARD => @location[:current] <= @route.list.size - 2, BACKWARD => !@location[:current].zero? }

      def fetch_current_location
        @location[:current] += move[@direction] if can_move?[@direction]
      end

      def fetch_previous_location = @location[:previous] = !can_move?[@direction] ? nil : @location[:current] - 1
      def fetch_next_location     = @location[:next]     = !can_move?[@direction] ? nil : @location[:current] + 1
    end
  end
end
