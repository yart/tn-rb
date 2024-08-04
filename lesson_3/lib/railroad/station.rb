# frozen_string_literal: true

module Railroad
  # Manages stations.
  class Station
    attr_reader :name

    def initialize(name)
      @name = name
      @trains = []
    end

    def trains(type = nil) = type.nil? ? @trains : @trains.select { _1.type == type }
    def handle(train)      = @trains << train
    def send(train)        = @trains.delete(train)
  end
end
