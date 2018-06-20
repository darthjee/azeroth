module Azeroth::Resourceable
  class ResourceBuilder
    attr_reader :model, :builder

    delegate :add_method, to: :builder

    def initialize(model, builder)
      @model = model
      @builder = builder
    end

    def append
      add_method(model.plural, "@#{model.plural} ||= #{model.klass}.all")
      add_method(model.name,   "@#{model.name} ||= #{model.plural}.find(#{model.name}_id)")
    end
  end
end
