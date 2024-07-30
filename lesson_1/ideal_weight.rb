# frozen_string_literal: true

# Calculates a human “ideal” weight.
module HumanIdealWeight
  MODIFIER = 110
  RATIO    = 1.15
  MESSAGE  = 'Ваш вес уже оптимальный'

  # Describes a human with his name, height and weight.
  class Human
    attr_reader :name, :weight

    # @param name [String]
    # @param height [Integer]
    def initialize(name, height)
      @name   = name
      @height = height

      calculate_weight
    end

    # @return [Boolean]
    def optimal_weight?
      @weight.negative?
    end

    private

    def calculate_weight
      @weight = (@height - MODIFIER) * RATIO
    end
  end

  # Provides simple UI tools.
  module UI
    # @param prompt [String] will be shown to user
    # @return [String, Integer] according ot user input
    def input(prompt)
      print "#{prompt} > "
      string = gets.chomp

      string == string.to_i.to_s ? string.to_i : string
    end
  end

  extend UI

  def self.run
    puts 'Приложение попытается определить ваш «идеальный» вес.'

    name   = input('Напишите ваше имя')
    height = input('Напишите ваш рост в сантиметрах')
    @user  = Human.new(name, height)

    puts perform_answer
  end

  # @return [String]
  def self.perform_answer
    @user.optimal_weight? ? MESSAGE : "#{@user.name}, ваш «идеальный» вес #{@user.weight.round(2)} кг."
  end
end

HumanIdealWeight.run
