# frozen_string_literal: true

module CUI
  class List
    # The Item class represents a single menu item within a list.
    # It encapsulates a value and its display label, providing a simple abstraction for menu elements.
    class Item
      attr_reader :value, :label

      # Initializes a new Item object with the specified value and label.
      #
      # @param value [Symbol] Represents the unique identifier of the menu item, typically used in program logic.
      #   This value is converted to a symbol to ensure consistent and expected behavior.
      # @param label [String] The textual label of the menu item, displayed in the user interface.
      #   It is converted to a string to ensure it is ready for output display.
      def initialize(value, label)
        @value = value.to_sym
        @label = label.to_s
      end

      # Provides the string representation of the menu item, primarily for display purposes.
      #
      # @return [String] The label of the item, which is shown in the menu.
      def to_s = @label
    end
  end
end
