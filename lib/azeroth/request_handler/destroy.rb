# frozen_string_literal: true

module Azeroth
  class RequestHandler
    # @api private
    #
    # hadler for requests to destroy resources
    class Destroy < RequestHandler
      private

      # @private
      #
      # Destroy and return an instance of the model
      #
      # @return [Object]
      def resource
        resource = controller.send(model.name)
        resource.tap(&:destroy)
      end
    end
  end
end
