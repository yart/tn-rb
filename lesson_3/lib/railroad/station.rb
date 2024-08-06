# frozen_string_literal: true

module Lesson3
  module Railroad
    # Manages stations.
    class Station
      attr_reader :name

      # @param name [String]
      def initialize(name)
        @name = name
        @trains = []
      end

      # @param type [Symbol] :cargo, :passenger, optional, default is nil
      # @return [Array<Railroad::Train>]
      def trains(type = nil) = type.nil? ? @trains : @trains.select { _1.type == type }
      # @param train [Railroad::Train]
      # @return [Array<Railroad::Train>]
      def handle(train)      = @trains << train
      # @param train [Railroad::Train]
      # @return [Railroad::Train, nil]
      def send(train)        = @trains.delete(train)
    end
  end
end
