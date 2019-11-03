# frozen_string_literal: true

require 'active_support'

module Azeroth
  # @api public
  # @author Darthjee
  #
  # Concern for building controller methods for the routes
  module Resourceable
    extend ActiveSupport::Concern

    autoload :Builder, 'azeroth/resourceable/builder'
    autoload :ClassMethods, 'azeroth/resourceable/class_methods'

    private

    def render_basic
      action = params[:action]
      respond_to do |format|
        format.json { render json: send("#{action}_resource") }
        format.html { action }
      end
    end
  end
end
