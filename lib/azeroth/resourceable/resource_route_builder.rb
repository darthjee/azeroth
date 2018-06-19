module Azeroth::Resourceable
  class ResourceRouteBuilder
    attr_reader :resource, :builder

    delegate :add_method, to: :builder

    def initialize(resource, builder)
      @resource = resource
      @builder = builder
    end

    def append
      add_method(:new_resource,    "@new_resource ||= #{resource_class}.new")
      add_method(:create_resource, "@create_resource ||= #{resource_class}.create(#{resource}_params)")
      add_method(:update_resource, "@update_resource ||= #{resource}.tap { |v| v.update(#{resource}_params) }")
      add_method(:index_resource,  resource_plural)
      add_method(:edit_resource,   resource)
      add_method(:show_resource,   resource)
    end

    private

    def resource_class
      @resource_class ||= resource.camelize.constantize
    end

    def resource_plural
      resource.pluralize
    end
  end
end

