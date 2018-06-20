module Azeroth::Resourceable
  class ResourceBuilder
    attr_reader :resource, :builder

    delegate :add_method, to: :builder

    def initialize(resource, builder)
      @resource = resource
      @builder = builder
    end

    def append
      add_method(resource_plural,  "@#{resource_plural} ||= #{resource_class}.all")
      add_method(resource,         "@#{resource} ||= #{resource_plural}.find(#{resource}_id)")
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
