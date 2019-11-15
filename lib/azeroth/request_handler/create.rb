# frozen_string_literal: true

module Azeroth
  class RequestHandler
    class Create < RequestHandler
      private

      def resource
        attributes = controller.send("#{model.name}_params")
        collection = controller.send(model.plural)
        collection.create(attributes)
      end
    end
  end
end
