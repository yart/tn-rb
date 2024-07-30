# frozen_string_literal: true

module EntertainingMath
  # Trig calculations
  module Trig
    # Triangle calculations.
    class Triangle
      AREA_RATIO = 0.5

      # @param basement [Integer, Float]
      # @param height [Integer, Float]
      def self.area(basement, height)
        AREA_RATIO * basement * height
      end
    end

    # @param basement [Integer, Float]
    # @param height [Integer, Float]
    def self.triangle_area(basement, height) = Triangle.area(basement, height)
  end
end
