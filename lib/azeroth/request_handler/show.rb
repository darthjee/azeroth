# frozen_string_literal: true

module Azeroth
  class RequestHandler
    # @api private
    #
    # hadler for requests to show a resource
    class Show < RequestHandler
      private

      # @private
      #
      # Finds and return an instance of the model
      #
      # finding happens through calling the controller
      # method +"#{model.name}"+
      #
      # @return [Object]
      def resource
        controller.send(model.name)
      end
    end
  end
end
