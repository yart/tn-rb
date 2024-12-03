# frozen_string_literal: true

# This file includes input-related classes within the CUI (Console User Interface) module.
# It focuses on facilitating user input for various types, such as text and numbers,
# and supports both singular and bulk data entry.

require_relative 'input/numerable'
require_relative 'input/text'
require_relative 'input/number'
require_relative 'input/bulk_text'
require_relative 'input/bulk_number'

module CUI
  # The Input module offers a suite of tools for acquiring data from users in a console application.
  # It is designed to streamline the process of collecting different types of input, including single
  # text or number entries, as well as bulk entries for handling lists. The module makes use of several
  # specialized classes to process input according to specified settings.
  module Input
    # Constant for specifying text input type.
    TEXT   = :text
    # Constant for specifying number input type.
    NUMBER = :number

    # @deprecated
    class << self
      # Initiates creation of an input object based on the provided settings.
      #
      # This method is retained primarily for backward compatibility.
      # It initializes the appropriate class for handling user input based
      # on the specified type and configuration.
      #
      # @param [Hash] settings Settings that determine the type of input and its behavior.
      # @option settings [String] :text Description or label for the input prompt.
      # @option settings [String] :prompt The prompt symbol or string, defaults to '>'.
      # @option settings [Symbol] :type Expected input type, defaults to :text.
      # @option settings [Boolean] :list Indicates if a list of values is expected, defaults to false.
      # @option settings [Integer] :max_items Specifies the maximum number of items in a list, if applicable.
      # @option settings [String] :separator Defines the separator for list items, defaults to comma.
      # @option settings [Boolean] :allow_negatives Allows negative numbers if the input type is Integer, defaults to false.
      # @return [Text, Number, BulkText, BulkNumber] An instance of the relevant input class based on settings.
      def new(**settings)
        @type = settings[:type] || TEXT
        @list = settings[:list] || false

        settings[:label] = settings[:text]
        settings[:limit] = settings[:max_items]

        perform_instance(**settings)
      end

      private

      # Determines which input class to instantiate based on settings.
      #
      # It checks the settings for input type and whether a list is expected,
      # selecting and initializing the appropriate input handling class.
      #
      # @see .new
      # @return [Text, Number, BulkText, BulkNumber] Instance of the appropriate input class.
      def perform_instance(**settings)
        object = Text.new(**settings)       if type_text?
        object = Number.new(**settings)     if type_number?
        object = BulkText.new(**settings)   if type_bulk_text?
        object = BulkNumber.new(**settings) if type_bulk_number?

        object
      end

      # Determines if the input type is a single number.
      #
      # @return [Boolean] True if the input type is a single number, otherwise false.
      def type_number?      = !@list && @type == NUMBER

      # Determines if the input type is a single text entry.
      #
      # @return [Boolean] True if the input type is text, otherwise false.
      def type_text?        = !@list && @type == TEXT

      # Determines if the input type is a list of numbers.
      #
      # @return [Boolean] True if the input type is a list of numbers, otherwise false.
      def type_bulk_number? =  @list && @type == NUMBER

      # Determines if the input type is a list of text entries.
      #
      # @return [Boolean] True if the input type is a list of text entries, otherwise false.
      def type_bulk_text?   =  @list && @type == TEXT
    end
  end
end
