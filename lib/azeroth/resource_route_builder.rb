module Azeroth
  class ResourceRouteBuilder
    attr_reader :model, :builder

    delegate :add_method, to: :builder

    def initialize(model, builder)
      @model = model
      @builder = builder
    end

    def append
      add_new_reource
      add_create_resource
      add_update_resource

      add_method(:index_resource,  model.plural)
      add_method(:edit_resource,   model.name)
      add_method(:show_resource,   model.name)
    end

    private

    def add_new_reource
      add_method(:new_resource, "@new_resource ||= #{model.klass}.new")
    end

    def add_create_resource
      add_method(
        :create_resource,
        "@create_resource ||= #{model.klass}.create(#{model.name}_params)"
      )
    end

    def add_update_resource
      add_method(
        :update_resource,
        <<-CODE
          @update_resource ||= #{model.name}.tap do |value|
            value.update(#{model.name}_params)
          end
        CODE
      )
    end
  end
end
