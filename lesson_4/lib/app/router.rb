# frozen_string_literal: true

require_relative 'router/controller_factory'
require_relative 'router/config'
require_relative 'router/parser'

module Lesson4
  module App
    module Router
      class RoutingError < StandardError; end

      @routes = {}

      class << self
        attr_reader :routes

        def draw
          Config.load_routes('config/routes.rb')
        rescue Errno::ENOENT
          raise RoutingError, 'Routes file not found'
        end

        def route(path_with_query)
          path, query = Parser.split_path_and_query(path_with_query)
          route = find_route(path)

          raise RoutingError, "Route not found: #{path}" unless route

          controller_name = route[:controller].to_s
          action = route[:action].to_s

          controller_class = ControllerFactory.get_controller(controller_name)
          controller_instance = controller_class.new({ query: Parser.parse_query(query) }.merge(route[:params]))

          controller_instance.public_send(action)
        end

        def reset!
          @routes = {}
        end

        private

        def find_route(path)
          @routes.each do |pattern, info|
            match = pattern.match(path)
            if match
              params = Parser.extract_dynamic_params(info[:path], path)
              return info.merge(params: params)
            end
          end
          nil
        end

        def constantize(camel_cased_word)
          camel_cased_word.split('_').map(&:capitalize).join
        end
      end
    end
  end
end
