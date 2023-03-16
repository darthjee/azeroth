# frozen_string_literal: true

require 'sinclair'

module Azeroth
  module Resourceable
    # @api private
    # Builder responsible to add all methods to the controller
    #
    # Builder uses other builders to put together it's methods
    #
    # @see ResourceBuilder
    # @see ResourceRouteBuilder
    # @see RoutesBuilder
    class Builder
      # @param clazz [ActionController::Base] Controller to
      #   to be changed
      # @param model_name [Symbol,String]
      # @param options [Options]
      def initialize(clazz, model_name, options)
        @clazz = clazz
        @options = options
        @model = Azeroth::Model.new(model_name, options)

        add_params
        add_resource
        add_routes
        add_helpers
      end

      private

      attr_reader :clazz, :model, :options
      # @method clazz
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

      # @method options
      # @api private
      # @private
      #
      # Options
      #
      # @return [Options]

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
        @builder ||= Sinclair.new(clazz)
      end

      # Add methods for id and parameters
      #
      # @return [Array<Sinclair::MethodDefinition>]
      def add_params
        ParamsBuilder.new(
          model: model, builder: builder
        ).append
      end

      # Add methods for resource fetching
      #
      # @return [Array<Sinclair::MethodDefinition>]
      def add_resource
        ResourceBuilder.new(model: model, builder: builder).append
      end

      # Add metohods for each route
      #
      # @return [Array<Sinclair::MethodDefinition>]
      def add_routes
        RoutesBuilder.new(
          model: model, builder: builder, options: options
        ).append
      end

      # Add helpers to render objects on template
      #
      # @return [String]
      def add_helpers
        clazz.public_send(:helper_method, model.name)
        clazz.public_send(:helper_method, model.plural)
      end
    end
  end
end
