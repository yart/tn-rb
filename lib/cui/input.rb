# frozen_string_literal: true

module CUI
  # Provides a simple input tools for getting data from users.
  class Input
    TEXT    = :text
    NUMBER  = :number

    # @param settings [Hash]
    # @option settings [String] :text an explanation for prompt
    # @option settings [String] :prompt '> " by default
    # @option settings [Symbol] :type of expected user input, :text by default
    # @option settings [Boolean] :list a list of elements or a single value, false by default
    # @option settings [Integer] :max_items of list if tt has been  defined, 1 by default
    # @option settings [String] :separator of list items, comma by default
    # @option settings [Boolean] :allow_negatives when input type is Integer, false by default
    def initialize(**settings)
      @text   = settings[:text]
      @prompt = settings[:prompt] || '> '
      @type   = settings[:type]   || TEXT
      @list   = settings[:list]   || false

      @line_counter = 0

      perform_prompt
      perform_list(settings)
    end

    # @return [String, Integer, Array<String, Integer>] according ot user input
    def receive
      result = list? ? list : convert(input_stream)
      clear_lines

      result
    end

    private

    CLEAR_LINE = "\r\e[A\e[K"
    CONVERT    = { TEXT => :to_s, NUMBER => :to_i }.freeze

    # @return [Boolean]
    def type_number?
      @type == NUMBER
    end

    # @return [Boolean]
    def type_text?
      @type == TEXT
    end

    # @return [Boolean]
    def list?
      @list
    end

    # @return [nil]
    def perform_prompt
      @text   = "#{@text} " unless @text.nil?
      @prompt = "#{@text}#{@prompt}"

      nil
    end

    # @return [nil]
    def perform_list(settings)
      if list?
        @max_items = settings[:max_items] || 1
        @separator = settings[:separator] || ','
      end
      @allow_negatives = settings[:allow_negatives] || false if list? && type_number?

      nil
    end

    # @return [String, Integer]
    def convert(entity)
      entity.send(CONVERT[@type])
    end

    # @return [#read]
    def input_stream
      @line_counter += 1
      print @prompt
      gets.chomp
    end

    def clear_lines
      @line_counter.times { $stdout.print CLEAR_LINE }
      @line_counter = 0
    end

    # @return [Regexp]
    def numbers
      @minus = '-' if @allow_negatives
      /[^#{@minus}0-9#{@separator}]/
    end

    def list_trait?(entity)
      return entity.instance_of?(Integer) if type_number?

      !/#{@separator}/.match?(entity) if type_text?
    end

    def split_list(entity)
      entity = entity.gsub(numbers, '') if type_number?
      entity.squeeze(',').split(',').map(&CONVERT[@type]).take(@max_items)
    end

    def list
      result     = []
      user_input = nil

      loop do
        return result if result.size == @max_items

        user_input = input_stream

        if list_trait?(user_input)
          result << user_input
          next
        end

        splitted_user_input = split_list(user_input)

        return splitted_user_input if splitted_user_input.count == @max_items

        result += splitted_user_input
      end
    end
  end
end
