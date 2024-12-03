# frozen_string_literal: true

require_relative 'list/item'

module CUI
  # The List class is responsible for constructing and managing a menu interface.
  # It builds upon menu-related aspects such as display, navigation, and item management.
  #
  # It includes common view and control capabilities to provide an interactive menu experience.
  class List
    include View
    include Control

    attr_reader :parent

    # Initializes a new List object with the specified settings for constructing menu options and behavior.
    #
    # @param settings [Hash] a hash containing configuration options for the menu.
    # @option settings [Hash{Symbol => String}, Array<Array<Symbol, String>>] :items Specifies the menu items,
    #   each defined by a symbol and a display text string.
    # @option settings [Integer] :default Sets the default starting index of the selected item. Defaults to 0.
    # @option settings [String] :pointer Defines the string used to indicate the currently selected item. Default is '=>'.
    # @option settings [String] :go_back Text displayed for the 'go back' menu option. Default is '<<<<<<<'.
    # @option settings [String] :quit Text displayed for the 'quit' option. Default is '(*<* )/'.
    # @option settings [CUI::List] :parent References a parent list if this list is a child. Enables hierarchical navigation.
    # @option settings [String] :header Text to display at the top of the menu as a header.
    # @option settings [String] :footer Text to display at the bottom of the menu as a footer.
    def initialize(**settings)
      @position = settings[:default] || 0
      @pointer  = settings[:pointer] || '=>'
      @go_back  = settings[:go_back] || '<<<<<<<'
      @quit     = settings[:quit]    || '(*<* )/'
      @parent   = settings[:parent]
      @header   = settings[:header]
      @footer   = settings[:footer]

      define_items(settings) # Initializes the menu items based on the given settings.
      line_count # Calculates the number of lines in the menu for drawing purposes.
    end

    # Initiates the menu selection process, allowing user interaction to navigate and make a choice.
    #
    # @return [Symbol, nil] The selected menu item's symbol, or nil if navigation is cancelled.
    def select
      display do
        until select? || go_back? || quit?
          draw_list    # Draws the current state of the menu list to the screen.
          read_char    # Awaits and processes user key input.
          drop_list    # Removes the current list display from the console.
          move_pointer # Adjusts the selection pointer based on input.
        end
      end

      selection
    end

    # Determines if this list has a parent list, indicating it is part of a menu hierarchy.
    #
    # @return [Boolean] Returns true if the list has a parent, indicating it is a child list.
    def child? = !@parent.nil?

    private

    # Renders the list on the console, including header, items, and footer.
    def draw_list
      draw(@header)
      @items.each_with_index { draw("#{pointer(_2)} #{_1}") }
      draw(@footer)
    end

    # Clears the number of console lines occupied by the menu display.
    def drop_list
      @lines.times { clear_line }
    end

    # Computes the display string for the pointer, based on the current selection index.
    #
    # @param index [Integer] The index to be checked against the current selection.
    # @return [String] The pointer string if the index is selected, otherwise spaces equivalent to the pointer size.
    def pointer(index) = @position == index ? @pointer : ' ' * @pointer.size

    # Initializes the @items instance variable with Item objects based on given settings.
    #
    # @param settings [Hash] A hash containing menu item configuration.
    def define_items(settings)
      items = []
      items << (@parent.nil? ? [:quit, @quit] : [:go_back, @go_back])
      items += settings[:items].to_a

      @items = items.map { Item.new(*_1) }
    end

    # Computes the number of lines in the menu, including header and footer.
    def line_count
      @lines = (@header.nil? ? 0 : 1) + (@footer.nil? ? 0 : 1) + @items.count
    end
  end
end
