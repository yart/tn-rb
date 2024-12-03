# frozen_string_literal: true

module CUI
  # The View module provides methods for managing the console display and TTY (TeleTYpewriter) cursor.
  # It enables efficient rendering of user interface elements and ensures that cursor visibility
  # is managed correctly during interaction.
  module View
    private

    # Draws an element to the console.
    #
    # Outputs a provided string element to the console. It allows control over whether the output
    # ends with a newline or not, enabling flexible formatting options.
    #
    # @param [String, nil] element The element to be output to the console.
    # @param [Boolean] new_line (true) If true, outputs a newline after the element; otherwise, keeps the cursor on the same line.
    # @return [void]
    def draw(element, new_line: true)
      $stdout.send(new_line ? :puts : :print, element) unless element.nil?
    end

    # Synchronizes and manages display output.
    #
    # Ensures that TTY cursor visibility is maintained during display operations by temporarily hiding
    # the cursor. This method yields a block where display-related tasks are executed, guaranteeing
    # consistent output without cursor flickering.
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
    # Temporarily hides the cursor from the console display, which is useful during operations
    # where cursor movement or rapid output changes could distract the user.
    #
    # @return [void]
    def hide_tty_cursor = draw(HIDE_CURSOR, new_line: false)

    # Shows the TTY cursor.
    #
    # Restores the display of the cursor in the console, reversing the effect of hide_tty_cursor.
    # This ensures that the cursor is visible during user input or when interaction completes.
    #
    # @return [void]
    def show_tty_cursor = draw(SHOW_CURSOR, new_line: false)

    # Clears the current line in the console.
    #
    # Removes all content from the current line in the terminal, typically used to refresh the display
    # or reset the line for new content.
    #
    # @return [void]
    def clear_line = draw(CLEAR_LINE, new_line: false)
  end
end
