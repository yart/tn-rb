# frozen_string_literal: true

module Lesson4
  module App
    module Router
      module Config
        def self.set(path, to: nil)
          raise RoutingError, "Duplicate route: #{path}" if Router.routes.key?(Parser.path_to_regex(path))

          controller, action = to&.split('#') || [path.split('/')[1], path.split('/').last]
          regex = Parser.path_to_regex(path)

          Router.routes[regex] = { path: path, controller: controller.to_sym, action: action.to_sym }
        end

        def self.load_routes(file)
          routes_code = File.read(file)

          raise RoutingError, "Routes file #{file} should contain at least on route!" if routes_code.empty?

          eval(routes_code, binding)
        end
      end
    end
  end
end
