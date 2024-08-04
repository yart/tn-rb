# frozen_string_literal: true

module Railroad
  # Manages routes.
  class Route
    STATIONS_ON_START = 2

    # When wrong number of arguments was passed to .new
    class StationsNumberError < ::StandardError
      def initialize(number)
        message_begin = number.zero? ? 'No stations' : 'Only one station'
        message_begin = "#{number} stations" if number > STATIONS_ON_START
        super "#{message_begin} station given, must be only two!"
      end
    end

    def initialize(*list)
      raise StationsNumberError, list.size if list.size != STATIONS_ON_START

      @list = list
    end

    def list
      @list.map(&:name)
    end

    def add(station)
      @list.insert(-2, station)
    end

    def remove(station)
      @list.delete(station) if station != @list.first || station != @list.last
    end
  end
end
