# frozen_string_literal: true

module CUI
  # Cursor control for lists and other interactive elements.
  module Control
    private

    def selection
      return :go_back if go_back? && child?
      return :quit    if go_back? && !child? || quit?

      @items[@position].label
    ensure
      @key = nil
    end

    def read_char
      @result = []

      $stdin.raw do |stdin|
        @char = stdin.getc
        @result << @char
        read_composite_char(stdin) if @char == "\e"
      end

      @key = @result.join
    end

    def read_composite_char(stream)
      @result << @char while (@char = Timeout.timeout(0.0001) { stream.getc })
    rescue Timeout::Error
      # do nothing
    end

    def move_pointer
      @position += 1 if !last_line?  && move_down?
      @position -= 1 if !first_line? && move_up?
    end

    def move_up?    = @key == KEY_ARROW_UP    || @key =~ KEY_UP_RE
    def move_down?  = @key == KEY_ARROW_DOWN  || @key =~ KEY_DOWN_RE
    def select?     = @key == KEY_ARROW_RIGHT || @key =~ KEY_RIGHT_RE || @key == KEY_RETURN
    def go_back?    = @key == KEY_ARROW_LEFT  || @key =~ KEY_LEFT_RE
    def quit?       = @key == QUICK_QUIT      || @key =~ KEY_QUIT_RE
    def first_line? = @position.zero?
    def last_line?  = @position == @items.count - 1
  end
end
