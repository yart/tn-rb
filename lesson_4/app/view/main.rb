# frozen_string_literal: true

module Lesson4
  module App
    module View
      # Builds and draws app's main menu.
      class Main < BaseMenu
        def list = CUI::List.new(**list_settings)

        private

        def perform_list
          [
            [:quit,     l10n_defaults(:quit)],
            [:stations, l10n_main_menu(:stations)],
            [:routes,   l10n_main_menu(:routes)],
            [:trains,   l10n_main_menu(:trains)]
          ]
        end
      end
    end
  end
end
