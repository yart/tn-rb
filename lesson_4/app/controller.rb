# frozen_string_literal: true

module Lesson4
  module App
    module Controller
      # Base class for all controllers in the application.
      #
      # Provides shared functionality and a common interface for all controllers.
      # Controllers are responsible for handling user input and coordinating
      # interaction between models and views.
      #
      # @abstract Subclasses must implement the {#execute} method.
      #
      # @example Expected behavior of associated view
      #   view = DummyView.new
      #   controller = Lesson4::App::Controller::Base.new(view)
      #   controller.execute # raises NotImplementedError
      #
      # The associated view must respond to:
      # - `#render`: renders content to the user interface.
      class BaseController
        # @return [#render] The view instance associated with this controller.
        attr_reader :view

        # Initializes a new controller with a given view instance.
        #
        # @param view [#render] The view instance to interact with. It must respond to `#render`.
        def initialize(view)
          @view = view
        end

        # Executes the primary action of the controller.
        #
        # Subclasses must override this method to define specific behavior.
        #
        # @raise [NotImplementedError] if the method is not overridden.
        def execute
          raise NotImplementedError, 'Subclasses must implement the #execute method'
        end
      end
    end
  end
end

require_relative 'controller/routes_controller'
require_relative 'controller/stations_controller'
require_relative 'controller/trains_controller'
