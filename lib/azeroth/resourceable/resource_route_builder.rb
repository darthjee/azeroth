module Azeroth::Resourceable
  class ResourceRouteBuilder
    attr_reader :model, :builder

    delegate :add_method, to: :builder

    def initialize(model, builder)
      @model = model
      @builder = builder
    end

    def append
      add_method(:new_resource,    "@new_resource ||= #{model.klass}.new")
      add_method(:create_resource, "@create_resource ||= #{model.klass}.create(#{model.name}_params)")
      add_method(:update_resource, "@update_resource ||= #{model.name}.tap { |v| v.update(#{model.name}_params) }")
      add_method(:index_resource,  model.plural)
      add_method(:edit_resource,   model.name)
      add_method(:show_resource,   model.name)
    end
  end
end

