# frozen_string_literal: true

module CUI
  # Provides a simple input tools for getting data from users.
  module Input
    # Provides methods for hanbling numbers.
    module Numerable
      def setup_floats(**settings)    = @float = !!settings[:float]
      def setup_negatives(**settings) = @allow_negatives = !!settings[:allow_negatives]
      # @return [Integer]
      def convert(entity) = @float ? entity.to_f : entity.to_i
      # @return [Array<Integer>]
      def bulk_convert(entities) = entities.map(&:to_i)
    end
  end
end
