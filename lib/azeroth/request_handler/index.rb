# frozen_string_literal: true

module Azeroth
  class RequestHandler
    # @api private
    #
    # hadler for requests to list resources
    class Index < RequestHandler
      private

      # @private
      #
      # return a collection of the model
      #
      # @return [Enumerable<Object>]
      def resource
        controller.send(model.plural)
      end
    end
  end
end
