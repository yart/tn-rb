# frozen_string_literal: true

require_relative 'router/error'
require_relative 'router/controller_factory'
require_relative 'router/config'
require_relative 'router/parser'

module Lesson4
  module TrueWay
    # The Router module handles routing logic for a console application.
    #
    # It reads user input, matches it against predefined routes,
    # and executes the corresponding controller actions.
    #
    # This module supports dynamic routing and various error handling mechanisms
    # including not found routes, invalid route formats, and missing files.
    #
    # @example Defining Routes with DSL
    #   # In config/routes.rb
    #   set '/', to: 'main_menu#list'           # Routes root path to MainMenuController's list action
    #   set '/stations/list'                    # Routes '/stations/list' to StationsController's list action
    #   set '/stations/add', to: 'stations#add' # Routes '/stations/add' to StationsController's add action
    #   set '/stations/:id/edit'                # Dynamic routing, allowing for paths like '/stations/42/edit'
    module Router
      @routes = {}

      class << self
        # @return [Hash] the collection of routes, keyed by regex pattern
        attr_reader :routes

        # Loads and initializes routes from a configuration file.
        #
        # @raise [Error::RoutesFileNotFoundError] if the routes file is not found
        def draw = load_routes

        # Routes a given path and query to the appropriate controller and action.
        #
        # @param path_with_query [String] the incoming request path and query string
        # @raise [Error::RouteNotFoundError] if no matching route is found
        # @raise [Error::InvalidRouteFormatError] if the path is improperly formatted
        def route(path_with_query)
          path, query = Parser.split_path_and_query(path_with_query)
          validate_route_format!(path)
          route_info = find_route(path)

          process_route(route_info, query)
        end

        # Resets the routes collection, clearing all defined routes.
        def reset! = @routes.clear

        private

        # Loads routes from the specified file.
        #
        # @see Config.load_routes
        def load_routes
          routes_path = TrueWay::Config.routes_path
          Config.load_routes(routes_path)
        rescue Errno::ENOENT
          raise Error::RoutesFileNotFoundError, routes_path
        end

        # Validates the format of the path.
        #
        # @param path [String] the path to validate
        # @raise [Error::InvalidRouteFormatError] if the path contains invalid characters
        def validate_route_format!(path)
          raise Error::InvalidRouteFormatError, path if path.nil? || path.match(%r{[^\w/\-_]})
        end

        # Finds route information based on the path.
        #
        # @param path [String] the requested path
        # @return [Hash] the route information including controller and action
        # @raise [Error::RouteNotFoundError] if no matching route is found
        def find_route(path)
          @routes.each do |pattern, info|
            return create_route_info(info, path) if pattern.match(path)
          end
          raise Error::RouteNotFoundError, path
        end

        # Processes the routing by invoking the controller action.
        #
        # @param route_info [Hash] the details of the route
        # @param query [String] the query string from the request
        # @raise [Error::ControllerNotFoundError] if the specified controller is not found
        def process_route(route_info, query)
          controller_name, action = route_info.values_at(:controller, :action).map(&:to_s)
          controller_class        = ControllerFactory.get_controller(controller_name)
          raise Error::ControllerNotFoundError unless controller_class

          controller_instance = controller_class.new({ query: Parser.parse_query(query) }.merge(route_info[:params]))
          controller_instance.dispatch_action(action)
        end

        # Creates detailed route information by extracting parameters.
        #
        # @param info [Hash] the base route information
        # @param path [String] the path used for extraction
        # @return [Hash] enriched route information with parameters
        def create_route_info(info, path)
          params = Parser.extract_dynamic_params(info[:path], path)
          info.merge(params: params)
        end
      end
    end
  end
end
