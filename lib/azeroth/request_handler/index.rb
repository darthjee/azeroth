# frozen_string_literal: true

module Azeroth
  class RequestHandler
    # @api private
    #
    # hadler for requests to list resources
    class Index < RequestHandler
      private

      delegate :paginated, to: :options

      # @private
      #
      # return a collection of the model
      #
      # @return [Enumerable<Object>]
      def resource
        return scoped_entries unless paginated
        scoped_entries.limit(20)
      end

      def scoped_entries
        controller.send(model.plural)
      end
    end
  end
end
