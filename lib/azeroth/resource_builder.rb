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
    # @param model [Model] Resource model interface
    # @param builder [Sinclair] method builder
    def initialize(model, builder)
      @model = model
      @builder = builder
    end

    # Add methods to be built
    #
    # Methods are the listing of all entities and fetching
    # of an specific entity
    #
    # @return [Array<Sinclair::MethodDefinition>]
    def append
      add_method(plural, "@#{plural} ||= #{model.klass}.all")
      add_method(name, "@#{name} ||= #{plural}.find(#{name}_id)")
    end

    private

    delegate :add_method, to: :builder
    # @api private
    # @method add_method
    #
    # Add a method to be build on the controller
    #
    # @return [Array<Sinclair::MethodDefinition>]

    delegate :name, :plural, to: :model
    # @method name
    # @api private
    #
    # Returns the name of the resource represented by the model
    #
    # @return [String]

    # @method plural
    # @api private
    #
    # Return the pluralized version of resource name
    #
    # @return [String]

    attr_reader :model, :builder
    # @method model
    # @api private
    # @private
    #
    # Returns the model class of the resource
    #
    # @return [Model]

    # @method builder
    # @api private
    # @private
    #
    # Returns a method builder
    #
    # @return [Sinclair]
    #
    # @see https://www.rubydoc.info/gems/sinclair Sinclair
  end
end
