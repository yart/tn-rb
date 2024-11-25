# frozen_string_literal: true

module Lesson4
  module App
    class Config
      # Provides a routing DSL for defining application menus and dynamically resolving controllers.
      #
      # This class allows defining application routes in a block-based DSL. It also supports
      # dynamic resolution of controller classes based on naming conventions.
      class Routes
        @routes = {}

        class << self
          # @!attribute [r] routes
          #   @return [Hash<Symbol, Object>] Registered routes as a hash with keys as menu names.
          attr_reader :routes

          # Defines routes using a DSL block.
          #
          # @example
          #   Lesson4::App::Config::Routes.draw do
          #     menu :dashboards, to: DashboardsController.new
          #   end
          #
          # @yield A block in which menus and routes can be defined.
          # @return [void]
          def draw(&block)
            instance_eval(&block)
          end

          # Registers a menu route.
          #
          # @param key [Symbol] The key representing the menu.
          # @param to [Object] The target object to associate with the menu (e.g., a controller instance).
          # @return [void]
          # @example
          #   menu :dashboards, to: DashboardsController.new
          def menu(key, to:)
            routes[key] = to
          end

          # Clears all registered routes.
          #
          # @return [void]
          def clear
            @routes = {}
          end

          # Dynamically resolves controller shortcuts.
          #
          # @param method_name [Symbol] The method name being called.
          # @return [Object] The resolved controller class.
          # @raise [NameError] if the controller class cannot be resolved.
          # @example
          #   Lesson4::App::Config::Routes.dashboards_controller
          def method_missing(method_name, *_args)
            if method_name.to_s.end_with?('_controller')
              class_name = camelize(method_name.to_s.sub('_controller', ''))
              resolve_controller_class(class_name)
            else
              super
            end
          end

          # Checks if a method is a valid controller shortcut.
          #
          # @param method_name [Symbol] The method name being queried.
          # @param include_private [Boolean] Whether to include private methods in the check.
          # @return [Boolean] True if the method is a valid controller shortcut, false otherwise.
          def respond_to_missing?(method_name, include_private = false)
            if method_name.to_s.end_with?('_controller')
              controller_name = camelize(method_name.to_s)
              Lesson4::App::Controller.const_defined?(controller_name)
            else
              super
            end
          end

          private

          # Resolves a controller class by its name.
          #
          # @param class_name [String] The name of the controller class.
          # @return [Object] The resolved controller class.
          # @raise [NameError] if the class cannot be resolved.
          def resolve_controller_class(class_name)
            Lesson4::App::Controller.const_get("#{class_name}Controller")
          rescue NameError
            raise NameError, "undefined method `#{underscore(class_name)}_controller`"
          end

          # Converts a string to CamelCase.
          #
          # @param string [String] The string to convert.
          # @return [String] The CamelCase representation.
          def camelize(string)
            string.split('_').map(&:capitalize).join
          end

          # Converts a string to snake_case.
          #
          # @param string [String] The string to convert.
          # @return [String] The snake_case representation.
          def underscore(string)
            string.gsub(/([A-Z])/, '_\1').downcase.sub(/^_/, '')
          end
        end
      end
    end
  end
end
