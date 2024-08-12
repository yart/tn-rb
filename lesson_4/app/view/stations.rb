# frozen_string_literal: true

module Lesson4
  module App
    module View
      # Builds and draws the stations menu.
      class Stations < BaseMenu
        def add  = CUI::Input::Text.new(**addition_settings)
        def edit = CUI::Input::Text.new(**edition_settings)

        private

        def list_settings     = super.merge(header: i10n_stations(:list))
        def addition_settings = { label: l10n_stations(:add),  prompt: l10n_stations(:add_prompt) }
        def edition_settings  = { label: l10n_stations(:edit), prompt: l10n_stations(:edit_prompt) }

        def perform_list = [[:go_back, l10n_defaults(:back)], [:add, l10n_defaults(:add)]] + fetch_list
        def fetch_list   = @list.transform_values { "#{l10n_defaults(:edit)}#{_1[:name]}" }.to_a
      end
    end
  end
end
