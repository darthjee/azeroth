# frozen_string_literal: true

require 'active_support'

module Azeroth
  # @api public
  # @author Darthjee
  #
  # Concern for building controller methods for the routes
  module Resourceable
    extend ActiveSupport::Concern

    included do
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
    end

    autoload :Builder, 'azeroth/resourceable/builder'
    autoload :ClassMethods, 'azeroth/resourceable/class_methods'

    private

    # @api private
    # @private
    #
    # Perform rendering of an action based on the requested format
    #
    # @return [String]
    def render_basic
      action = params[:action]
      respond_to do |format|
        format.json { render json: send("#{action}_resource") }
        format.html { action }
      end
    end

    # @api private
    # @private
    #
    # returns 404 as HTTP status
    #
    # @return [TrueClass]
    def not_found
      head :not_found
    end
  end
end
