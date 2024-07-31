# frozen_string_literal: true

module EntertainingMath
  # Algebraic calculations
  module Algebra
    NO_ROOTS = :no_roots

    class << self
      # @param coeffs [Array<Integer>] must contain 2 - 3 items
      # @return [Symbol]
      def square_roots(*coeffs)
        discriminant(coeffs)

        return NO_ROOTS if @discriminant.negative?

        roots(coeffs).uniq
      end

      private

      def discriminant(coeffs)
        @discriminant = coeffs[1]**2 - 4 * coeffs[0] * coeffs[2]
      end

      def roots(coeffs)
        divider = 2 * coeffs[0]
        sqrt_d = Math.sqrt(@discriminant)

        [(-coeffs[1] + sqrt_d) / divider, (-coeffs[1] - sqrt_d) / divider]
      end
    end
  end
end
