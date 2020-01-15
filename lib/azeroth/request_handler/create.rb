# frozen_string_literal: true

module Azeroth
  class RequestHandler
    # @api private
    #
    # hadler for requests to create resources
    class Create < RequestHandler
      private

      # @private
      #
      # Creates and return an instance of the model
      #
      # creation uses the method +"#{model.name}_params"+ to
      # fetch all allowed attributes for creation
      #
      # @return [Object]
      def resource
        @resource ||= build_resource
      end
      
      def build_resource
        attributes = controller.send("#{model.name}_params")
        collection = controller.send(model.plural)
        collection.create(attributes)
      end

      def status
        resource.valid? ? :created : :unprocessable_entity
      end
    end
  end
end
