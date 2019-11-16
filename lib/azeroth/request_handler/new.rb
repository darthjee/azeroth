# frozen_string_literal: true

module Azeroth
  class RequestHandler
    # @api private
    #
    # hadler for requests for new resources
    class New < RequestHandler
      private

      # @private
      #
      # returns a new empty instance of the model
      #
      # the initialization of the model uses the collection
      # so that any attribute related to the collection
      # will be present
      #
      # @return [Object]
      def resource
        controller.send(model.plural).new
      end
    end
  end
end
