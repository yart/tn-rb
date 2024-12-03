# frozen_string_literal: true

module CUI
  module Input
    # The BulkText class is designed to handle bulk text input from the user.
    # It extends the basic functionality of the Text class to segment the input into lists preferentially.
    # This class supports custom settings, such as the maximum number of elements and different separators.
    class BulkText < Text
      # The default value for separators in string lists
      SEPARATOR = ','

      # Initializes a new BulkText object.
      #
      # @param [Hash] settings settings for processing the input.
      # @option settings [Integer] :limit The maximum number of elements in the input data.
      # @option settings [String] :separator The character used to separate items in the list.
      def initialize(**settings)
        super(**settings)
        @limit     = settings[:limit]
        @separator = settings[:separator] || SEPARATOR
      end

      # Initiates the process of receiving input from the user.
      #
      # @return [Array<String>] An array of strings or numbers representing the parsed user input.
      def receive
        result = receive_list
        clear_lines
        result
      end

      private

      # Checks if there is a limit on the number of elements.
      def limited? = @limit.is_a?(Integer) && @limit > 0

      # Checks if the limit on the number of elements in the array has been reached.
      def limit_reached?(entities) = limited? && entities.size >= @limit

      # Determines if the user has canceled the input. Implies input completion without limits.
      def cancelled_by_user?(input) = !limited? && input.strip.empty?

      # Splits the input string into a list, abiding by the set limit.
      #
      # @param [String] input The input string to be split.
      # @param [Array<String>] result The current array of results.
      # @return [Array<String>] The split array of elements.
      def split_list(input, result)
        list = input.split(@separator).map(&:strip).reject(&:empty?)
        limited? ? list.take(@limit - result.size) : list
      end

      # Checks if the input is a single item without separators.
      def single_item?(input) = !input.include?(@separator)

      # Converts the array of elements. Can be overridden for specialized processing.
      #
      # @param [Array] entities The array of elements to convert.
      # @return [Array] The converted elements.
      def bulk_convert(entities) = entities

      # Receives and processes user input, managing lists and constraints.
      #
      # @return [Array<String>] The final array of input results.
      def receive_list
        result = []
        loop do
          break if limit_reached?(result)

          user_input = input_stream

          break if user_input.nil? || cancelled_by_user?(user_input)
          next if user_input.strip.empty?

          result += single_item?(user_input) ? [user_input] : split_list(user_input, result)
        end
        bulk_convert(result)
      end
    end
  end
end
