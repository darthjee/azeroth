# frozen_string_literal: true

module Azeroth
  class RequestHandler
    # @api private
    #
    # hadler for requests to list resources
    class Index < RequestHandler
      private

      delegate :paginated?, :per_page, to: :options

      # @private
      #
      # return a collection of the model
      #
      # @return [Enumerable<Object>]
      def resource
        return scoped_entries unless paginated?
        paginated_entries
      end

      def paginated_entries
        scoped_entries.offset(offset).limit(per_page)
      end

      def offset
        page = (params[:page] || 1) - 1
        page * limit
      end

      def limit
        per_page
      end

      def scoped_entries
        controller.send(model.plural)
      end
    end
  end
end
