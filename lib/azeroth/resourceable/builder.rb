require 'sinclair'

module Azeroth::Resourceable
  class Builder < Sinclair
    delegate :resource, to: :options_object

    def initialize(clazz, resource, **options)
      super(clazz, resource: resource.to_s, **options)

      add_params
      add_resource
      add_resource_for_routes
      add_routes
    end

    private

    def add_params
      add_method("#{resource}_id",     "params.require(:id)")
      add_method("#{resource}_params", "params.require(:#{resource}).permit(:#{permitted_attributes.join(', :')})")
    end

    def add_resource
      add_method(resource_plural,  "@#{resource_plural} ||= #{resource_class}.all")
      add_method(resource,         "@#{resource} ||= #{resource_plural}.find(#{resource}_id)")
    end

    def add_resource_for_routes
      add_method(:new_resource,    "@new_resource ||= #{resource_class}.new")
      add_method(:create_resource, "@create_resource ||= #{resource_class}.create(#{resource}_params)")
      add_method(:update_resource, "@update_resource ||= #{resource}.tap { |v| v.update(#{resource}_params) }")
      add_method(:index_resource,  resource_plural)
      add_method(:edit_resource,   resource)
      add_method(:show_resource,   resource)
    end

    def add_routes
      %i(index show new edit create update).each do |route|
        add_method(route, 'render_basic')
      end
      add_method(:destroy, %{
        #{resource}.destroy
        head :no_content
      })

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
