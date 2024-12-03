# frozen_string_literal: true

module CUI
  # The Control module provides methods for managing cursor movement and user interactions
  # within lists and other interactive console elements. It defines how keyboard input
  # is interpreted to navigate through menu options and select or exit items.

  # Contains private methods to handle key reading and navigation logic.
  module Control
    private

    # Determines the current item of selection based on navigation actions.
    #
    # @return [Symbol, nil] Returns :go_back if navigating back, :quit if quitting, otherwise
    #   returns the label of the currently selected item or nil when something went wrong.
    def selection
      return :go_back if go_back? && child? # Indicates going back in a submenu.
      return :quit    if go_back? && !child? || quit? # Indicates quitting the menu.

      @items[@position].value # Returns the label of the currently selected menu item.
    ensure
      @key = nil
    end

    # Reads a single character from standard input, handling both simple and escape sequences.
    def read_char
      @result = []

      $stdin.raw do |stdin|
        @char = stdin.getc
        @result << @char
        read_composite_char(stdin) if @char == "\e" # Read additional characters for escape sequences.
      end

      @key = @result.join # Joins characters into a single string key identifier.
    end

    # Reads additional characters from the input stream to complete composite (escape) keys.
    def read_composite_char(stream)
      @result << @char while (@char = Timeout.timeout(0.0001) { stream.getc })
    rescue Timeout::Error
      # If there's a timeout, assume the escape sequence is complete and exit.
    end

    # Moves the selection pointer based on the input key and current position.
    def move_pointer
      @position += 1 if !last_line?  && move_down? # Move down if not at the last item.
      @position -= 1 if !first_line? && move_up?   # Move up if not at the first item.
    end

    # Determines if the up key has been pressed.
    #
    # @return [Boolean] True if the key corresponds to an up movement.
    def move_up? = @key == KEY_ARROW_UP || KEY_UP_RE.match?(@key)

    # Determines if the down key has been pressed.
    #
    # @return [Boolean] True if the key corresponds to a down movement.
    def move_down? = @key == KEY_ARROW_DOWN || KEY_DOWN_RE.match?(@key)

    # Determines if the select (right or enter) key has been pressed.
    #
    # @return [Boolean] True if the key corresponds to a selection action.
    def select? = @key == KEY_ARROW_RIGHT || KEY_RIGHT_RE.match?(@key) || @key == KEY_RETURN

    # Determines if the back (left) key has been pressed.
    #
    # @return [Boolean] True if the key corresponds to a go-back action.
    def go_back? = @key == KEY_ARROW_LEFT || KEY_LEFT_RE.match?(@key)

    # Determines if the quit key has been pressed.
    #
    # @return [Boolean] True if the key corresponds to a quit action.
    def quit? = @key == QUICK_QUIT || KEY_QUIT_RE.match?(@key)

    # Checks if the current position is the first item of the list.
    #
    # @return [Boolean] True if the current position is zero.
    def first_line? = @position.zero?

    # Checks if the current position is the last item of the list.
    #
    # @return [Boolean] True if the current position is at the last item.
    def last_line? = @position == @items.count - 1
  end
end
