# frozen_string_literal: true

module Lesson4
  module App
    module Controller
      # Controls data transfering between station menu and model
      class Stations
        def initialize
          @stations = View::Stations.new(Model::Station.all)
        end

        def list
          selected = @stations.list.select

          return selected if selected == :quit

          add if selected == :add

          edit(selected) if selected != :add && selected != :quit
        end

        def add = View::Stations.new(Model::Station.new)

        def edit(uuid) = View::Stations.new(Model::Stations.find(uuid))
      end
    end
  end
end
