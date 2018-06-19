require 'sinclair'

module Azeroth::Resourceable
  class Builder
    attr_reader :clazz, :resource

    delegate :build, :add_method, to: :builder

    def initialize(clazz, resource, **options)
      @clazz = clazz
      @resource = resource.to_s

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
      add_method("#{resource}_id",     "params.require(:id)")
      add_method("#{resource}_params", "params.require(:#{resource}).permit(:#{permitted_attributes.join(', :')})")
    end

    def add_resource
      add_method(resource_plural,  "@#{resource_plural} ||= #{resource_class}.all")
      add_method(resource,         "@#{resource} ||= #{resource_plural}.find(#{resource}_id)")
    end

    def add_resource_for_routes
      ResourceRouteBuilder.new(resource, builder).append
    end

    def add_routes
      RoutesBuilder.new(resource, builder).append
    end

    def resource_class
      @resource_class ||= resource.camelize.constantize
    end

    def permitted_attributes
      @permitted_attributes ||= resource_class.attribute_names - ['id']
    end

    def resource_plural
      resource.pluralize
    end
  end
end
