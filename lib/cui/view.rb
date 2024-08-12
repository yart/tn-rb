# frozen_string_literal: true

module CUI
  # Outputs elements to TTY.
  module View
    private

    def draw(element, new_line: true)
      $stdout.send(new_line ? :puts : :print, element) unless element.nil?
    end

    def display
      $stdout.sync = true
      hide_tty_cursor
      yield
    rescue SystemExit
      exit 0
    rescue StandardError => e
      raise e
    ensure
      $stdout.sync = false
      show_tty_cursor
    end

    def hide_tty_cursor = draw(HIDE_CURSOR, new_line: false)
    def show_tty_cursor = draw(SHOW_CURSOR, new_line: false)
    def clear_line      = draw(CLEAR_LINE,  new_line: false)
  end
end
