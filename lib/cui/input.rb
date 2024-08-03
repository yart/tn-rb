# frozen_string_literal: true

require_relative 'input/numerable'
require_relative 'input/text'
require_relative 'input/number'
require_relative 'input/bulk_text'
require_relative 'input/bulk_number'

module CUI
  # Provides a simple input tools for getting data from users.
  module Input
    TEXT    = :text
    NUMBER  = :number

    # @deprecated
    class << self
      # Creates an object of an input class depending on given settings.
      #
      # @note The method left only for reverse compatibility.
      #
      # @param [Hash] settings
      # @option settings [String] :text an explanation for prompt
      # @option settings [String] :prompt '> " by default
      # @option settings [Symbol] :type of expected user input, :text by default
      # @option settings [Boolean] :list a list of elements or a single value, false by default
      # @option settings [Integer] :max_items of list if tt has been defined
      # @option settings [String] :separator of list items, comma by default
      # @option settings [Boolean] :allow_negatives when input type is Integer, false by default
      # @return [Text, Number, BulkText, BulkNumber]
      def new(**settings)
        @type = settings[:type] || TEXT
        @list = settings[:list] || false

        settings[:label] = settings[:text]
        settings[:limit] = settings[:max_items]

        perform_instance(**settings)
      end

      private

      # @see .new
      def perform_instance(**settings)
        object = Text.new(**settings)       if type_text?
        object = Number.new(**settings)     if type_number?
        object = BulkText.new(**settings)   if type_bulk_text?
        object = BulkNumber.new(**settings) if type_bulk_number?

        object
      end

      # @return [Boolean]
      def type_number?      = !@list && @type == NUMBER
      # @return [Boolean]
      def type_text?        = !@list && @type == TEXT
      # @return [Boolean]
      def type_bulk_number? =  @list && @type == NUMBER
      # @return [Boolean]
      def type_bulk_text?   =  @list && @type == TEXT
    end
  end
end
