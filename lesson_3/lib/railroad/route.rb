# frozen_string_literal: true

module Railroad
  # Manages routes.
  class Route
    STATIONS_ON_START = 2

    # When wrong number of arguments was passed to .new
    class StationsNumberError < ::StandardError
      # @param number [Integer]
      def initialize(number)
        message_begin = number.zero? ? 'No stations' : 'Only one station'
        message_begin = "#{number} stations" if number > STATIONS_ON_START
        super "#{message_begin} station given, must be only two!"
      end
    end

    # @param list [Array<Railroad::Station>]
    def initialize(*list) = list.size != STATIONS_ON_START ? raise(StationsNumberError, list.size) : @list = list

    # @return [Array<String>]
    def list              = @list.map(&:name)
    # @param station [Railroad::Station]
    # @return [Array<Railroad::Station>]
    def add(station)      = @list.insert(-2, station)

    # @param station [Railroad::Station]
    # @return [Array<Railroad::Station>, nil]
    def remove(station)
      @list.delete(station) if station != @list.first || station != @list.last
    end
  end
end
