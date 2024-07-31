# frozen_string_literal: true

module EntertainingMath
  # Calculates a human “ideal” weight.
  module IdealWeight
    include CUI

    MESSAGE = 'Ваш вес уже оптимальный'

    # Describes a human with his name, height and weight.
    class Human
      MODIFIER = 110
      RATIO    = 1.15

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

    def self.run
      puts 'Приложение попытается определить ваш «идеальный» вес.'

      name   = Input.new(text: 'Напишите ваше имя').receive
      height = Input.new(text: 'Напишите ваш рост в сантиметрах', type: Input::NUMBER).receive
      @user  = Human.new(name, height)

      puts perform_answer
    end

    # @return [String]
    def self.perform_answer
      @user.optimal_weight? ? MESSAGE : "#{@user.name}, ваш «идеальный» вес #{@user.weight.round(2)} кг."
    end
  end
end
