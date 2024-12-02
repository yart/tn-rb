# frozen_string_literal: true

module CUI
  # Outputs elements to TTY (TeleTYpewriter), providing methods
  # for console display and cursor management.
  module View
    private

    # Draws an element to the console.
    #
    # @param [String] element The element to be output to the console.
    # @param [Boolean] new_line (true) If true, outputs a newline after the element; otherwise, keeps the cursor on the same line.
    # @return [void]
    def draw(element, new_line: true)
      $stdout.send(new_line ? :puts : :print, element) unless element.nil?
    end

    # Synchronizes and manages display output, ensuring that TTY cursor visibility is maintained.
    # This method provides a block for executing display-related tasks.
    #
    # @yield Performs the block operations, ensuring consistent display output.
    # @return [void]
    def display
      previous_sync = $stdout.sync
      $stdout.sync = true
      hide_tty_cursor
      yield
    ensure
      show_tty_cursor
      $stdout.sync = previous_sync
    end

    # Hides the TTY cursor.
    #
    # @return [void]
    def hide_tty_cursor = draw(HIDE_CURSOR, new_line: false)

    # Shows the TTY cursor.
    #
    # @return [void]
    def show_tty_cursor = draw(SHOW_CURSOR, new_line: false)

    # Clears the current line in the console.
    #
    # @return [void]
    def clear_line = draw(CLEAR_LINE, new_line: false)
  end
end
