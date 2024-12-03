# frozen_string_literal: true

module CUI
  # The CUI module defines a set of constants used for controlling and displaying
  # user interface elements in a console application. It includes key codes for
  # navigation and actions, as well as sequences for manipulating cursor visibility
  # and screen content.

  # Control Keys
  # These constants represent keyboard arrow keys and common shortcuts for navigation and quitting:
  KEY_ARROW_UP    = "\e[A"     # The escape sequence for the up arrow key.
  KEY_ARROW_DOWN  = "\e[B"     # The escape sequence for the down arrow key.
  KEY_ARROW_RIGHT = "\e[C"     # The escape sequence for the right arrow key.
  KEY_ARROW_LEFT  = "\e[D"     # The escape sequence for the left arrow key.

  # Regular expressions for alternative navigation keys, allowing for more intuitive or memorable controls:
  KEY_UP_RE       = /^[kpw]$/i # Matches 'k', 'p', or 'w' (case insensitive) as up commands.
  KEY_DOWN_RE     = /^[jns]$/i # Matches 'j', 'n', or 's' (case insensitive) as down commands.
  KEY_RIGHT_RE    = /^[del]$/i # Matches 'd', 'e', or 'l' (case insensitive) as right commands.
  KEY_LEFT_RE     = /^[abh]$/i # Matches 'a', 'b', or 'h' (case insensitive) as left commands.
  KEY_QUIT_RE     = /^q$/i     # Matches 'q' (case insensitive) to quit the application.
  KEY_RETURN      = "\r"       # The carriage return key, often used to confirm selections.
  QUICK_QUIT      = "\u0003"   # Control-C (^C) for an immediate quit command.

  # View Controls
  # These constants provide control over the visibility and behavior of the cursor and line clearing in the terminal:
  HIDE_CURSOR     = "\e[?25l"  # Escape sequence to hide the cursor during menu interaction.
  SHOW_CURSOR     = "\e[?25h"  # Escape sequence to show the cursor after menu interaction.
  CLEAR_LINE      = "\r\e[A\e[K" # Sequence to clear the current line and move the cursor up, useful for dynamic interface updates.
end
