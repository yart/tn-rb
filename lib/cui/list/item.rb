# frozen_string_literal: true

module CUI
  class List
    # Describes a menu item.
    class Item
      attr_reader :value

      # @param value [Symbol]
      # @param label [String]
      def initialize(value, label)
        @value = value.to_sym
        @label = label.to_s
      end

      def to_s = @label
    end
  end
end
