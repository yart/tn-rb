# frozen_string_literal: true

require 'erb'

module Lesson4
  module TrueWay
    # View class responsible for rendering ERB templates
    # using the provided context. This class encapsulates
    # the rendering logic and can be reused throughout the application.
    class View
      # Initializes a new instance of the View class.
      #
      # @param context [Binding] The context containing variables and methods
      #   that should be accessible within the ERB template.
      def initialize(context)
        @context = context
      end

      # Renders the ERB template located at the specified path.
      #
      # @param path [String] The file system path to the ERB template
      #   that needs to be rendered.
      # @return [String] The rendered content as a string.
      def render(path)
        template = File.read(path)
        ERB.new(template).result(@context)
      end
    end
  end
end
