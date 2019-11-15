# frozen_string_literal: true

module Azeroth
  class RequestHandler
    class Update < RequestHandler
      private

      def resource
        attributes = controller.send("#{model.name}_params")
        resource = controller.send(model.name)
        resource.update(attributes)
        resource
      end
    end
  end
end
