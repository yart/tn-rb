# frozen_string_literal: true

module CUI
  # Provides a simple input tools for getting data from users.
  module Input
    # Provides basic functionality for bulk console input.
    class BulkText < Text
      SEPARATOR = ','

      # @param [Hash] settings
      # @option settings [String] :label an explanation for prompt
      # @option settings [String] :prompt '> " by default
      # @option settings [Integer] :limit of list if tt has been defined
      # @option settings [String] :separator of list items, comma by default
      # @option settings [Boolean] :allow_negatives when input type is Integer, false by default
      def initialize(**settings)
        super(**settings)

        @limit     = settings[:limit]
        @separator = settings[:separator] || SEPARATOR
      end

      # @return [Array<String, Integer>] according to user input
      def receive
        result = receive_list
        clear_lines

        result
      end

      private

      def limited? = !!@limit

      def limit_reached?(entity)     = limited? && entity.size >= @limit
      def cancelled_by_user?(entity) = !limited? && !entity.nil? && entity.empty?
      def split_list(entity)         = entity.squeeze(@separator).split(@separator).map(&:to_s).take(@limit)
      def list_trait?(entity)        = !/#{@separator}/.match?(entity)
      def bulk_convert(entities)     = entities

      def receive_list
        result     = []
        user_input = nil

        loop do
          return bulk_convert(result.take(@limit)) if limit_reached?(result)
          return bulk_convert(result)              if cancelled_by_user?(user_input)

          result << user_input && next if list_trait?(user_input = input_stream)

          result += split_list(user_input)
        end
      end
    end
  end
end
