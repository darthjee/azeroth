# frozen_string_literal: true

module Azeroth
  class RequestHandler
    # @api private
    #
    # Wrapper for request finding pagination attributes
    class Pagination
      def initialize(params, options)
        @params = params
        @options = options
      end

      delegate :per_page, to: :options

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
      # calculates current page
      #
      # @return [Integer]
      def current_page
        (params[:page] || 1).to_i
      end

      private

      attr_reader :params, :options
    end
  end
end
