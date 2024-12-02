# frozen_string_literal: true

module Lesson4
  module TrueWay
    module Controller
      # The Base class is responsible for handling controller actions
      # and rendering views.
      #
      # @attr_reader [Hash] params the parameters passed to the controller
      #
      # @example Creating a controller with actions for `/trains/list` and `/trains/:id/show`
      #   class ShowController < TrueWay::Controller::Base
      #     def list
      #     end
      #
      #     def show
      #       @train = find_train(params[:id])
      #       # Additional logic for displaying the train
      #     end
      #
      #     private
      #
      #     def find_train(id)
      #       Train.find(id)
      #     end
      #   end
      #
      class Base
        attr_reader :params

        # Initializes a new controller object with the given parameters.
        #
        # @param params [Hash] parameters for the controller
        def initialize(**params)
          @params    = params
          @performed = false
        end

        # Executes the specified action and renders the corresponding view.
        #
        # @param action_name [Symbol, String] the name of the action to execute
        def dispatch_action(action_name)
          @current_action = action_name.to_s

          return render(action_name) unless respond_to?(action_name)

          public_send(action_name)
          render(action_name) unless performed?
        end

        private

        # Renders the view for the specified or current action.
        #
        # @param template_name [Symbol, String, nil] name of the template
        def render(template_name = nil)
          @performed      = true
          template_name ||= @current_action
          view_path       = derive_view_path(template_name)
          view            = Lesson4::TrueWay::View.new(binding)
          view.render(view_path)
        end

        # Derives the path to the view template file.
        #
        # @param template_name [Symbol, String] name of the template
        # @return [String] path to the view file
        def derive_view_path(template_name)
          controller_name = self.class.name.split('::').last.sub(/Controller$/, '').gsub(/([a-z\d])([A-Z])/, '\1_\2').downcase
          "app/views/#{controller_name}/#{template_name}.txt.erb"
        end

        # Returns whether rendering has been performed.
        #
        # @return [Boolean] the status of rendering
        def performed? = @performed
      end
    end
  end
end
