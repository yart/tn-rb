# frozen_string_literal: true

module Lesson4
  module TrueWay
    module Router
      # The Parser module provides utility methods for handling and transforming
      # route paths and query parameters within the router.
      #
      # It includes methods to split paths from query strings, transform dynamic
      # segments into regular expressions, extract parameters, and parse query strings.
      module Parser
        class << self
          # Splits the given path into a path and query string component.
          #
          # It separates the path from the query parameters, returning both parts.
          #
          # @param path_with_query [String] the full path with query string
          # @return [(String, String)] an array containing the path and query string
          def split_path_and_query(path_with_query)
            path_with_query.split('?', 2).tap { |parts| parts[1] ||= '' }
          end

          # Converts a path with dynamic segments into a regular expression.
          #
          # This method transforms route paths with dynamic parts, e.g., ':id', into regex patterns.
          #
          # @param path [String] the path with dynamic segments
          # @return [Regexp] the regular expression matching the path
          def path_to_regex(path)
            Regexp.new("^#{path.gsub(/:\w+/, '\w+')}$")
          end

          # Extracts dynamic parameters from the given path against the actual received path.
          #
          # Compares the route path template with the actual request path and extracts parameters.
          #
          # @param route_path [String] the route path template with dynamic segments
          # @param actual_path [String] the actual path received in the request
          # @return [Hash] a hash of extracted parameter names and their values
          def extract_dynamic_params(route_path, actual_path)
            route_segments = route_path.split('/')
            actual_segments = actual_path.split('/')

            route_segments.each_with_index.with_object({}) do |(segment, index), params|
              params[segment.delete(':').to_sym] = actual_segments[index] if segment.start_with?(':')
            end
          end

          # Parses a query string into a hash of parameters.
          #
          # This method converts a URL query string into a hash with symbolized keys.
          #
          # @param query [String] the query string component of a URL
          # @return [Hash] a hash with key-value pairs from the query string
          def parse_query(query)
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
end
