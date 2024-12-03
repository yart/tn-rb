# frozen_string_literal: true

module CUI
  # The Input module encompasses utilities for obtaining and processing user input in console applications.
  module Input
    # The Numerable module provides tools for handling numerical input from users in a flexible manner.
    # It includes methods for configuring how numbers are processed, allowing for detailed
    # control over the input type (integers vs. floats) and constraints (negative numbers).
    module Numerable
      # Configures whether to handle floats in numerical input.
      #
      # This method sets up whether user input should be interpreted and converted to a float.
      # By default, all input is converted to integers unless configured otherwise.
      #
      # @param [Hash] settings Configuration settings for number handling.
      # @option settings [Boolean] :float (false) If true, user input is converted to a float;
      #   otherwise, it is converted to an integer.
      # @return [void]
      def setup_floats(**settings) = @float = !!settings[:float]

      # Configures whether negative numbers are allowed in numerical input.
      #
      # By default, the module is configured to only allow positive integers. This method enables
      # the acceptance of negative numbers based on configuration, providing flexibility in user inputs.
      #
      # @param [Hash] settings Configuration settings for number handling.
      # @option settings [Boolean] :allow_negatives (false) If true, negative numbers are allowed
      #   as valid input.
      # @return [void]
      def setup_negatives(**settings) = @allow_negatives = !!settings[:allow_negatives]

      # Converts a given input entity to a numerical value.
      #
      # Based on the initial setup, this method will convert the input entity to either an integer
      # or a float, facilitating consistent data processing.
      #
      # @param [String] entity The input string to be converted into a number.
      # @return [Integer, Float] The converted numerical value, returned as an integer or float
      #   depending on the configuration.
      def convert(entity) = @float ? entity.to_f : entity.to_i

      # Converts an array of string entities to an array of integers.
      #
      # This method batch-processes a list of input strings, converting them all to integers.
      # It is useful for handling bulk data entry scenarios where multiple entries need to be
      # interpreted as numbers.
      #
      # @param [Array<String>] entities An array of strings representing numbers.
      # @return [Array<Integer>] An array of converted integer values, derived from the input strings.
      def bulk_convert(entities) = entities.map(&:to_i)
    end
  end
end
