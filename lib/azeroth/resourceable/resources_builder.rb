# frozen_string_literal: true

require 'sinclair'

module Azeroth
  module Resourceable
    # @api private
    # Builder responsible to add resource / model methods to the controller
    #
    # Builder uses {ResourceBuilder} to put together it's methods
    #
    # @see ResourceBuilder
    class ResourcesBuilder
      # @param klass [ActionController::Base] Controller to
      #   to be changed
      # @param model_name [Symbol,String]
      def initialize(klass, model_name)
        @klass = klass
        @model = Azeroth::Model.new(model_name, Azeroth::Options.new({}))

        add_resource
        add_helpers
      end

      private

      attr_reader :klass, :model

      # @method klass
      # @api private
      # @private
      #
      # Controller to changed
      #
      # @return [ActionController::Base]

      # @method model
      # @api private
      # @private
      #
      # Model interface to resource model
      #
      # @return [Model]

      delegate :build, :add_method, to: :builder
      # @method build
      # @api private
      # @private
      #
      # build all the methods
      #
      # @return [Array<Sinclair::MethodDefinition>]

      # @method add_method
      # @api private
      #
      # Add method to be built
      #
      # @return [Array<Sinclair::MethodDefinition>]

      delegate :name, to: :model
      # @method name
      # @api private
      # @private
      #
      # Resource name
      #
      # @return [Symbol,String]

      # @api private
      # @private
      #
      # Returns a method builder
      #
      # @return [Sinclair]
      #
      # @see https://www.rubydoc.info/gems/sinclair Sinclair
      def builder
        @builder ||= Sinclair.new(klass)
      end

      # Add methods for resource fetching
      #
      # @return [Array<Sinclair::MethodDefinition>]
      def add_resource
        ResourceBuilder.new(model: model, builder: builder).append
      end

      # Add helpers to render objects on template
      #
      # @return [String]
      def add_helpers
        klass.helper_method(model.name)
        klass.helper_method(model.plural)
      end
    end
  end
end
