# frozen_string_literal: true

module EntertainingMath
  # Trig calculations
  module Trig
    # Triangle calculations.
    class Triangle
      AREA_RATIO = 0.5

      EQUILATERAL = :equilateral
      ISOSCELES   = :isosceles
      SQUARE      = :square
      CASUAL      = :casual

      class << self
        # @param basement [Integer, Float]
        # @param height [Integer, Float]
        def area(basement, height)
          AREA_RATIO * basement * height
        end

        # @param dimensions [Array<Integer>] must contain 3 items
        # @return [Symbol]
        def type(*dimensions)
          return EQUILATERAL if equilateral?(dimensions)
          return ISOSCELES   if isosceles?(dimensions)
          return SQUARE      if square?(dimensions)

          CASUAL
        end

        private

        def equilateral?(dimensions) = dimensions.uniq.size == 1
        def isosceles?(dimensions) = dimensions.uniq.size == 2

        def square?(dimensions)
          max = dimensions.delete(dimensions.max)

          max**2 == dimensions.first**2 + dimensions.last**2
        end
      end
    end

    # @param basement [Integer, Float]
    # @param height [Integer, Float]
    def self.triangle_area(*) = Triangle.area(*)
    # @param dimensions [Array<Integer>] must contain 3 items
    # @return [Symbol]
    def self.triangle_type(*) = Triangle.type(*)
  end
end
