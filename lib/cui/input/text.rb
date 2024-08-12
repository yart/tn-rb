# frozen_string_literal: true

module CUI
  # Provides a simple input tools for getting data from users.
  module Input
    # Provides basic functionality for console input.
    class Text
      include View

      PROMPT = '> '

      # @param [Hash] settings
      # @option settings [String] :label an explanation for prompt
      # @option settings [String] :prompt '> " by default
      def initialize(**settings)
        @label  = settings[:label]
        @prompt = settings[:prompt] || PROMPT
        @lines  = 0

        perform_prompt
      end

      # @return [String, Integer] according to user input
      def receive
        result = convert(input_stream)
        clear_lines

        result
      end

      private

      CLEAR_LINE = "\r\e[A\e[K"

      # @return [nil]
      def perform_prompt
        @label  = "#{@label} " unless @label.nil?
        @prompt = "#{@label}#{@prompt}"

        nil
      end

      def show_prompt
        @lines += 1
        print @prompt
      end

      # @return [#read]
      def input_stream
        show_prompt
        gets.chomp
      end

      def clear_lines
        @lines.times { clear_line }
        @lines = 0
      end

      # @return [#read]
      def convert(entity) = entity
    end
  end
end
