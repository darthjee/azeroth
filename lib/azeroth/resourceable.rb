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

    class_methods do
      # Adds resource methods for resource
      #
      # @param name [String, Symbol] Name of the resource
      # @param options [Hash]
      def resource_for(name, **options)
        Builder.new(
          self, name, Azeroth::Options.new(options)
        ).build
      end
    end
  end
end
