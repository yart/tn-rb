# frozen_string_literal: true

require_relative '../lib/cui'

module Lesson2
  class Item
    attr_reader :name, :price, :quantity

    def initialize(name:, price:, quantity:)
      @name     = name
      @price    = price
      @quantity = quantity.to_f
    end

    def cost
      @price * @quantity
    end

    def to_h
      { name => { price:, quantity:, cost: } }
    end
  end

  class Cart
    attr_accessor :items

    def initialize(items = {})
      @items = items
    end

    def add(item)
      @items.merge!(item.to_h)
    end

    def total
      items.values.inject(0) { |sum, item| sum + item[:cost] }
    end
  end

  class FillCart
    def initialize
      @name     = CUI::Input::Text.new(label: 'Название')
      @price    = CUI::Input::Number.new(label: 'Цена', float: true)
      @quantity = CUI::Input::Number.new(label: 'Количество', float: true)
      @cart     = Cart.new
    end

    def greeting
      puts 'Покупательская корзина.'
      puts 'Добавьте нужное количество товаров, заполняя название, цену и количество'
      puts 'каждого товара.'
      puts 'Введите "стоп" вместо назнаия товара, когда заполните корзину.'
    end

    def fill
      until (name = @name.receive) =~ /стоп/i
        price    = @price.receive
        quantity = @quantity.receive

        @cart.add(Item.new(name:, price:, quantity:))
      end
    end

    def total
      puts 'Ваша корзина содержит следующие товары:'
      puts @cart.items
      puts "\nОбщая стоимость товаров в корзине: #{@cart.total}"
    end
  end
end

fill_cart = Lesson2::FillCart.new

fill_cart.greeting
fill_cart.fill
fill_cart.total
