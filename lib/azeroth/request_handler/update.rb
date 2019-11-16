# frozen_string_literal: true

module Azeroth
  class RequestHandler
    # @api private
    #
    # hadler for requests to update resource
    class Update < RequestHandler
      private

      # @private
      #
      # Updates and return an instance of the model
      #
      # update uses the method +"#{model.name}_params"+ to
      # fetch all allowed attributes for update
      #
      # @return [Object]
      def resource
        attributes = controller.send("#{model.name}_params")
        resource = controller.send(model.name)
        resource.update(attributes)
        resource
      end
    end
  end
end
