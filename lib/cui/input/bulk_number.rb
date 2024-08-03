# frozen_string_literal: true

module CUI
  # Provides a simple input tools for getting data from users.
  module Input
    # Receives bulk numeric input from user.
    class BulkNumber < BulkText
      include Numerable

      # @param [Hash] settings
      # @option settings [String] :label an explanation for prompt
      # @option settings [String] :prompt '> " by default
      # @option settings [Integer] :limit of list if tt has been defined
      # @option settings [String] :separator of list items, comma by default
      # @option settings [Boolean] :allow_negatives when input type is Integer, false by default
      def initialize(**)
        super(**)
        setup_negatives(**)
      end

      private

      # @return [Regexp]
      def numbers
        @minus = '-' if @allow_negatives
        /[^#{@minus}0-9#{@separator}]/
      end

      def split_list(entity)
        entity.gsub(numbers, '').squeeze(',').split(',').map(&:to_i).take(@limit)
      end

      def list_trait?(entity)
        super(entity) && entity == entity.to_i.to_s
      end
    end
  end
end
