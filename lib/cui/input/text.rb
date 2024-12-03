# frozen_string_literal: true

module CUI
  # The Input module provides mechanisms for collecting user input within
  # console applications, incorporating various methods to streamline
  # the capture and processing of text-based data. It supports customizable
  # settings and easily extendable classes.
  module Input
    # The Text class provides basic functionality for handling console input.
    # It encapsulates the collection and processing of textual input from users,
    # offering a straightforward interface for displaying prompts and receiving user input.
    # The interface can be customized using settings, and it can be extended
    # for more specific behaviors.
    class Text
      include View

      # Default prompt string used for input.
      PROMPT = '> '

      # Initializes a new instance of the Text class.
      #
      # This constructor configures the text input prompt by integrating user-defined settings
      # such as prompt labels and the prompt string itself, providing a customizable input experience.
      #
      # @param [Hash] settings Configuration options for the input prompt.
      # @option settings [String] :label An optional label that precedes the prompt, providing context.
      # @option settings [String] :prompt ('> ') The string to display as a prompt.
      def initialize(**settings)
        @label  = settings[:label]
        @prompt = settings[:prompt] || PROMPT
        @lines  = 0

        perform_prompt
      end

      # Receives input from the user through the console interface.
      #
      # This method captures and processes user input, returning it in a suitable format.
      # It handles the display and clearance of prompt lines to maintain a clean console interface.
      # By default, returns a string, but can return any type if the `convert` method is overridden.
      #
      # @return [String, nil] The processed user input.
      def receive
        result = convert(input_stream)
        clear_lines

        result
      end

      private

      # Escape sequence for clearing lines in the console.
      CLEAR_LINE = "\r\e[A\e[K"

      # Integrates the explanation label with the prompt string.
      #
      # This method prepares the full prompt message by appending any provided label
      # to the default or specified prompt string, forming the complete user prompt.
      #
      # @return [nil]
      def perform_prompt
        @label  = "#{@label} " unless @label.nil?
        @prompt = "#{@label}#{@prompt}"

        nil
      end

      # Displays the configured prompt to the console to solicit user input.
      #
      # This method increments a line count to manage prompt display and
      # orchestrates user interaction by presenting the prepared prompt question.
      #
      # @return [void]
      def show_prompt
        @lines += 1
        print @prompt
      end

      # Reads input from the console, provided by the user.
      #
      # This method captures the user input, ensuring it is trimmed of whitespace
      # for accurate processing and storage.
      #
      # @return [String, nil] The string input from the user, or nil if input is EOF.
      def input_stream
        show_prompt
        input = gets
        return nil if input.nil?

        input.chomp
      end

      # Clears previously displayed lines from the console output.
      #
      # This method ensures a clean console by removing all prompt and input lines
      # after processing the user input, maintaining an uncluttered user interface.
      #
      # @return [void]
      def clear_lines
        @lines.times { clear_line }
        @lines = 0
      end

      # Converts the input entity. Subclasses may override this for specialized input conversion.
      #
      # This conversion method allows for specific input processing requirements
      # beyond basic text handling by overriding it in subclass implementations.
      #
      # @param [String, nil] entity The input entity to convert.
      # @return [String, nil] The converted input entity.
      def convert(entity) = entity
    end
  end
end
