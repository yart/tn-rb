# frozen_string_literal: true

module Lesson4
  module TrueWay
    module Router
      # The ControllerFactory is responsible for retrieving and handling controller classes by name.
      class ControllerFactory
        # Retrieves a controller class given its name.
        #
        # This method constructs the fully qualified name of the controller and checks if it is defined.
        #
        # @param name [String] the name of the controller
        # @return [Class] the controller class
        # @raise [Error::ControllerNotFoundError] if the controller is not found
        def self.get_controller(name)
          controller_name = "#{constantize(name)}Controller"

          raise Error::ControllerNotFoundError, "Controller not found: #{controller_name}" unless Object.const_defined?(controller_name)

          Object.const_get(controller_name)
        end

        # Converts a snake_case string to CamelCase.
        #
        # This utility method transforms a string with underscore separators into CamelCase format.
        #
        # @param camel_cased_word [String] the word to be converted
        # @return [String] the CamelCase version of the input
        def self.constantize(camel_cased_word)
          camel_cased_word.split('_').map(&:capitalize).join
        end
      end
    end
  end
end
