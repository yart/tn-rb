# frozen_string_literal: true

module Lesson4
  module TrueWay
    module Router
      module Config
        # Sets a route in the router configuration.
        #
        # This method registers a specified path to a controller action pair.
        # Raises a DuplicateRouteError if the route is already defined.
        #
        # @param path [String] the URL path to set for the route
        # @param to [String, nil] the controller and action in the format "controller#action"
        # @raise [Error::DuplicateRouteError] if the route is already registered
        #
        # @example
        #   Config.set('/users', to: 'users#index')
        def self.set(path, to: nil)
          raise Error::DuplicateRouteError.new(path) if Router.routes.key?(Parser.path_to_regex(path))

          controller, action = to&.split('#') || [path.split('/')[1], path.split('/').last]
          regex = Parser.path_to_regex(path)

          Router.routes[regex] = { path: path, controller: controller.to_sym, action: action.to_sym }
        end

        # Loads routes from a specified file into the router configuration.
        #
        # This method reads and processes a route file, executing it within a
        # safe DSL context to register all routes.
        #
        # @param file [String] the file path containing route definitions
        #
        # @example
        #   Config.load_routes('config/routes.rb')
        def self.load_routes(file)
          routes_code = File.read(file)

          safe_dsl_context = RouteDSL.new
          safe_dsl_context.instance_eval(routes_code)
        end

        # A domain-specific language (DSL) class for defining routes.
        #
        # This class provides a lightweight DSL context for setting routes
        # using the configuration methods.
        class RouteDSL
          # Registers a route using the DSL.
          #
          # @param path [String] the URL path to set for the route
          # @param to [String, nil] the controller and action in the format "controller#action"
          #
          # @example
          #   dsl.set('/products', to: 'products#show')
          def set(path, to: nil) = Config.set(path, to: to)
        end
      end
    end
  end
end
