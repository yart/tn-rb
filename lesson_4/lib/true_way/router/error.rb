# frozen_string_literal: true

module Lesson4
  module TrueWay
    module Router
      module Error
        # Base class for all router-related errors.
        class RouterError < StandardError; end

        # Raised when a requested route cannot be found.
        #
        # @param path [String] the path that could not be found
        class RouteNotFoundError < RouterError
          def initialize(path)
            super("Route not found: #{path}")
          end
        end

        # Raised when a route has an invalid format.
        #
        # @param path [String] the path with an invalid format
        class InvalidRouteFormatError < RouterError
          def initialize(path)
            super("Invalid route format: #{path}")
          end
        end

        # Raised when the routes file cannot be located.
        #
        # @param file [String] the name of the file that was not found
        class RoutesFileNotFoundError < RouterError
          def initialize(file)
            super("Routes file not found: #{file}")
          end
        end

        # Raised when a specified controller cannot be found.
        #
        # @param msg [String] the error message to be displayed (optional)
        class ControllerNotFoundError < RouterError
          def initialize(msg = 'Controller not found')
            super
          end
        end

        # Raised when a duplicate route is detected.
        #
        # @param path [String] the duplicated path
        class DuplicateRouteError < RouterError
          def initialize(path)
            super("Duplicate route: #{path}")
          end
        end
      end
    end
  end
end
