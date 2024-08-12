# frozen_string_literal: true

module Lesson4
  module App
    module View
      # Provides an abstract class to constract and draw app's menus.
      class BaseMenu
        # @param list [Hash{Symbol=>Hash{Symbol=>String,Number}}] keys are entities' UUIDs, values are entities' properties
        # @param parent [CUI::List] a parent's menu CUI::List instance
        def initialize(list, parent = nil)
          @list   = list
          @parent = parent
        end

        def list = CUI::List.new(**list_settings)
        def add  = raise NoMethodError
        def edit = raise NoMethodError

        private

        def list_settings
          {
            items:   perform_list,
            quit:    l10n_defaults(:quit),
            go_back: l10n_defaults(:back),
            parent:  @parent
          }
        end

        def perform_list = raise NoMethodError

        def l10n(id)           = App.l10n[:menu][id]
        def l10n_defaults(id)  = i10n(:defaults)[id]
        def l10n_main_menu(id) = i10n(:main)[id]
        def l10n_stations(id)  = i10n(:stations)[id]
        def l10n_routes(id)    = i10n(:routes)[id]
        def l10n_trains(id)    = i10n(:trains)[id]
      end
    end
  end
end
