# frozen_string_literal: true

module Lesson4
  module Railroad
    # Manages trains.
    class Train
      attr_accessor :speed
      attr_reader :number, :wagon_type, :wagons, :default_speed

      # @param number [String]
      # @param type [Symbol]
      # @param wagons [Integer]
      def initialize(number:)
        @number   = number
        @wagons   = []
        @speed    = 0
        @route    = []
        @location = { current: nil, previous: nil, next: nil }

        @wagon_type    = Wagon
        @default_speed = 100
      end

      # @return [Integer]
      def attach(wagon)
        return unless wagon.is_a?(wagon_type)

        @wagons << wagon if can_attach?
      end

      # @return [Integer, nil]
      def detach
        @wagons.pop if can_detach?
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

      def backward = go(:backward)
      def forward  = go(:forward)

      private

      # @param direction [Symbol]
      def go(direction)
        @direction = direction
        @speed     = default_speed

        fetch_current_location
        fetch_previous_location
        fetch_next_location
      end

      def can_attach? = speed.zero?
      def can_detach? = speed.zero? && !@wagons.count.zero?

      def move      = { forward: 1, backward: -1 }[@direction]
      def can_move? = { forward: @location[:current] < @route.list.size - 1, backward: !@location[:current].zero? }[@direction]

      def fetch_current_location
        @location[:current] += move if can_move?
      end

      def fetch_previous_location = @location[:previous] = can_move? ? @location[:current] - 1 : nil
      def fetch_next_location     = @location[:next]     = can_move? ? @location[:current] + 1 : nil
    end
  end
end
