# frozen_string_literal: true

module CUI
  # Provides a simple input tools for getting data from users.
  module Input
    # Provides basic functionality for console input.
    class Text
      PROMPT = '> '

      # @param [Hash] settings
      # @option settings [String] :label an explanation for prompt
      # @option settings [String] :prompt '> " by default
      def initialize(**settings)
        @label  = settings[:label]
        @prompt = settings[:prompt] || PROMPT

        @line_counter = 0

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
        @line_counter += 1
        print @prompt
      end

      # @return [#read]
      def input_stream
        show_prompt
        gets.chomp
      end

      def clear_lines
        @line_counter.times { $stdout.print CLEAR_LINE }
        @line_counter = 0
      end

      # @return [#read]
      def convert(entity) = entity
    end
  end
end
