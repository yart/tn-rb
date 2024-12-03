# frozen_string_literal: true

module CUI
  module Input
    # The BulkNumber class is designed for handling bulk numeric input from users.
    # It extends the functionality of the BulkText class and includes the Numerable module
    # to incorporate numeric-specific operations and validations.
    class BulkNumber < BulkText
      include Numerable

      # Initializes a new BulkNumber input object with specified settings.
      #
      # @param settings [Hash] a hash of configuration options.
      # @option settings [String] :label A description or instruction message displayed to the user for the input prompt.
      # @option settings [String] :prompt The character or string used to prompt the user. Defaults to '> ' if not specified.
      # @option settings [Integer] :limit Specifies the maximum number of numeric entries that can be input.
      # @option settings [String] :separator Defines the character used to separate multiple numeric entries. Defaults to a comma (',').
      # @option settings [Boolean] :allow_negatives Determines whether negative numbers are acceptable input values. By default, this is set to false.
      def initialize(**settings)
        super(**settings) # Initializes inherited properties from BulkText
        setup_negatives(**settings) # Configures settings related to negative input handling.
      end

      private

      # Constructs a regular expression pattern that matches non-numeric characters,
      # customized to allow separators and negatives if permitted.
      #
      # @return [Regexp] Regular expression for filtering non-numeric input characters.
      def numbers_regex
        minus = @allow_negatives ? '-' : ''
        /[^#{minus}0-9#{@separator}]/
      end

      # Splits the given input into an array of integers, sanitizing input by removing disallowed characters.
      #
      # @param input [String] The raw user input text to be split and processed.
      # @param result [Array<Integer>] The current list of collected inputs to consider the limit.
      # @return [Array<Integer>] List of integers parsed from the user's input, honoring the limit setting.
      def split_list(input, result)
        list = input.gsub(numbers_regex, '').squeeze(@separator).split(@separator).map(&:strip).reject(&:empty?).map(&:to_i)
        limited? ? list.take(@limit - result.size) : list
      end

      # Validates an input to determine if it is a standalone numeric value.
      #
      # @param input [String] User input to be checked for numeric identity.
      # @return [Boolean] Returns true if the input is a valid integer representation.
      def single_item?(input)
        super(input) && numeric?(input)
      end

      # Checks if the input is a valid integer (considering allow_negatives setting).
      #
      # @param input [String] The input string to check.
      # @return [Boolean] True if the input is a valid integer.
      def numeric?(input)
        pattern = @allow_negatives ? /\A-?\d+\z/ : /\A\d+\z/
        pattern.match?(input.strip)
      end
    end
  end
end
