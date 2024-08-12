# frozen_string_literal: true

module CUI
  # Control
  KEY_ARROW_UP    = "\e[A"
  KEY_ARROW_DOWN  = "\e[B"
  KEY_ARROW_RIGHT = "\e[C"
  KEY_ARROW_LEFT  = "\e[D"
  KEY_UP_RE       = /^[kpw]$/i
  KEY_DOWN_RE     = /^[jns]$/i
  KEY_RIGHT_RE    = /^[del]$/i
  KEY_LEFT_RE     = /^[abh]$/i
  KEY_QUIT_RE     = /^q$/i
  KEY_RETURN      = "\r"
  QUICK_QUIT      = "\u0003" # ^C

  # View
  HIDE_CURSOR     = "\e[?25l"
  SHOW_CURSOR     = "\e[?25h"
  CLEAR_LINE      = "\r\e[A\e[K"
end
