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
  class ResourceBuilder < Sinclair::Model
    # @!method initialize(model:, builder:, options:)
    #   @api private
    #
    #   @param model [Model] Resource model interface
    #   @param builder [Sinclair] method builder
    #   @param options [Azeroth::Options] options
    #
    #   @return [ResourceBuilder]
    initialize_with(:model, :builder, :options, writter: false)

    # Append methods to be built to the builder
    #
    # Methods are the listing of all entities and fetching
    # of an specific entity
    #
    # @return [Array<Sinclair::MethodDefinition>]
    def append
      add_method(plural, "@#{plural} ||= #{model.klass}.all")
      add_method(
        name,
        "@#{name} ||= #{plural}.find_by!(#{id_key}: #{name}_id)"
      )
    end

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

    delegate :id_key, to: :options
    # @method plural
    # @api private
    #
    # key used to find a model. id by default
    #
    # @return [Symbol]
  end
end
