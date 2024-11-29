module Lesson4
  module App
    module Router
      class ControllerFactory
        def self.get_controller(controller_name)
          controller_class_name = "#{constantize(controller_name)}Controller"
          Object.const_get(controller_class_name)
        rescue NameError
          raise RoutingError, "Controller not found: #{controller_class_name}"
        end

        def self.constantize(camel_cased_word)
          camel_cased_word.split('_').map(&:capitalize).join
        end
      end
    end
  end
end
