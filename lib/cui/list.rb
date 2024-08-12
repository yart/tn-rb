# frozen_string_literal: true

require_relative 'list/item'

module CUI
  # Builds menu.
  class List
    include View
    include Control

    attr_reader :parent

    # @param settings [Hash]
    # @option settings [Hash{Symbol => String}, Array<Array<Symbol, String>] :items
    # @option settings [Integer] :default 0 by default
    # @option settings [String] :pointer
    # @option settings [String] :go_back
    # @option settings [CUI::List] :parent
    # @option settings [String] :header
    # @option settings [String] :footer
    def initialize(**settings)
      @position = settings[:default] || 0
      @pointer  = settings[:pointer] || '=>'
      @go_back  = settings[:go_back] || '<<<<<<<'
      @quit     = settings[:quit]    || '(*<* )/'
      @parent   = settings[:parent]
      @header   = settings[:header]
      @footer   = settings[:footer]

      define_items(settings)
      line_count
    end

    def select
      display do
        until select? || go_back? || quit?
          draw_list
          read_char
          drop_list
          move_pointer
        end
      end

      selection
    end

    def child? = !@parent.nil?

    private

    def draw_list
      draw(@header)
      @items.each_with_index { draw("#{pointer(_2)} #{_1}") }
      draw(@footer)
    end

    def drop_list
      @lines.times { clear_line }
    end

    def pointer(index) = @position == index ? @pointer : ' ' * @pointer.size

    def define_items(settings)
      items = []
      items << @parent.nil? ? [:quit, @quit] : [:go_back, @go_back]
      items += settings[:items].to_a

      @items = items.map { Item.new(*_1) }
    end

    def line_count
      @lines = (@header.nil? ? 0 : 1) + (@footer.nil? ? 0 : 1) + @items.count
    end
  end
end
