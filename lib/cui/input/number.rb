# frozen_string_literal: true

module CUI
  # Provides a simple input tools for getting data from users.
  module Input
    # Recceives any numbers from user.
    class Number < Text
      include Numerable

      # @param [Hash] settings
      # @option settings [String] :label an explanation for prompt
      # @option settings [String] :prompt '> " by default
      # @option settings [Boolean] :float
      # @option settings [Boolean] :allow_negatives when input type is Integer, false by default
      def initialize(**)
        super(**)
        setup_floats(**)
        setup_negatives(**)
      end
    end
  end
end
