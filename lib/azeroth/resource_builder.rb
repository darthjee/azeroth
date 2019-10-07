# frozen_string_literal: true

module Azeroth
  # @api private
  # @author Darthjee
  #
  # Builder responsible for for building the resource methods
  #
  # The builder adds 2 methods, one for listing all
  # entries of a resource, and one for fetching an specific
  # entry
  class ResourceBuilder
    attr_reader :model, :builder
    # @method model
    # @api private
    #
    # Returns the model class of the resource
    #
    # @return [Model]

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
