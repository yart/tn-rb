# frozen_string_literal: true

module Lesson4
  module App
    module Router
      module Parser
        def self.split_path_and_query(path_with_query)
          path_with_query.split('?', 2).tap do |parts|
            parts[1] ||= ''
          end
        end

        def self.path_to_regex(path)
          Regexp.new('^' + path.gsub(/:\w+/, '\w+') + '$')
        end

        def self.extract_dynamic_params(route_path, actual_path)
          route_segments = route_path.split('/')
          actual_segments = actual_path.split('/')

          route_segments.each_with_index.with_object({}) do |(segment, index), params|
            params[segment.delete(':').to_sym] = actual_segments[index] if segment.start_with?(':')
          end
        end

        def self.parse_query(query)
          return {} if query.empty?

          query.split('&').each_with_object({}) do |pair, params|
            key, value = pair.split('=', 2)
            params[key.to_sym] = value || '' unless key.empty?
          end
        end
      end
    end
  end
end
