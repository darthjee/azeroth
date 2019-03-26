require 'sinclair'

module Azeroth
  module Resourceable
    class Builder
      attr_reader :clazz, :model, :options

      delegate :build, :add_method, to: :builder

      def initialize(clazz, model_name, options)
        @clazz = clazz
        @model = Azeroth::Model.new(model_name)
        @options = options

        add_params
        add_resource
        add_resource_for_routes
        add_routes
      end

      private

      def builder
        @builder ||= Sinclair.new(clazz)
      end

      def add_params
        add_method("#{model.name}_id", 'params.require(:id)')
        add_method(
          "#{model.name}_params",
          <<-CODE
            params.require(:#{model.name})
              .permit(:#{permitted_attributes.join(', :')})
          CODE
        )
      end

      def add_resource
        ResourceBuilder.new(model, builder).append
      end

      def add_resource_for_routes
        ResourceRouteBuilder.new(model, builder).append
      end

      def add_routes
        RoutesBuilder.new(model, builder, options).append
      end

      def permitted_attributes
        @permitted_attributes ||= model.klass.attribute_names - ['id']
      end
    end
  end
end
