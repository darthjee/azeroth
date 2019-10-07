# frozen_string_literal: true

module Azeroth
  class ResourceBuilder
    attr_reader :model, :builder

    delegate :add_method, to: :builder
    delegate :name, :plural, to: :model

    def initialize(model, builder)
      @model = model
      @builder = builder
    end

    def append
      add_method(plural, "@#{plural} ||= #{model.klass}.all")
      add_method(name, "@#{name} ||= #{plural}.find(#{name}_id)")
    end
  end
end
