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

      # @private
      #
      # returns pagination headers
      #
      # @return [Hash] heders
      def headers
        return {} unless paginated?

        {
          pages: pages,
          page: current_page,
          per_page: limit
        }
      end

      # @private
      #
      # paginated collection of the model
      #
      # @return [Enumerable<Object>]
      def paginated_entries
        scoped_entries.offset(offset).limit(limit)
      end

      # @private
      #
      # offest used in pagination
      #
      # offset is retrieved from +params[:per_page]+
      # or +options.per_page+
      #
      # @return [Integer]
      def offset
        (current_page - 1) * limit
      end

      # @private
      #
      # limit used in pagination
      #
      # limit is retrieved from +params[:page]+
      #
      # @return [Integer]
      def limit
        (params[:per_page] || per_page).to_i
      end

      # @private
      #
      # default scope of elements
      #
      # @return [Enumerable<Object>]
      def scoped_entries
        controller.send(model.plural)
      end

      # @private
      #
      # calculates current page
      #
      # @return [Integer]
      def current_page
        (params[:page] || 1).to_i
      end

      # @private
      #
      # calculates how many pages are there
      #
      # @return [Integer]
      def pages
        (scoped_entries.count.to_f / limit).ceil
      end
    end
  end
end
