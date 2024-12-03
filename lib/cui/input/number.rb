# frozen_string_literal: true

module CUI
  # This module provides tools for handling user input interactions
  # It includes different classes and modules for specific input types.
  module Input
    # The Number class is a specialized class for managing numerical input from users.
    # It inherits from the Text class and includes the Numerable module for
    # numerical operations and validations.
    class Number < Text
      include Numerable

      # Initializes a new Number input object.
      #
      # @param settings [Hash] a hash of configuration options.
      # @option settings [String] :label An explanation for the input prompt that is displayed to the user.
      #   This gives context or instructions on what input is expected.
      # @option settings [String] :prompt The character or string used to prompt the user for input.
      #   Defaults to '> ' if not specified.
      # @option settings [Boolean] :float Indicates if the input allows floating-point numbers.
      #   If true, the input accepts decimal values.
      # @option settings [Boolean] :allow_negatives Specifies if the input allows negative numbers
      #   when input type is Integer. By default, this is false to restrict input to positive numbers only.
      def initialize(**settings)
        super(**settings)
        setup_floats(**settings)
        setup_negatives(**settings)
      end
    end
  end
end
