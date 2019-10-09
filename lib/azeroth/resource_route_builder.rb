# frozen_string_literal: true

module Azeroth
  # @api private
  # @author Darthjee
  #
  # Builder for resources for each route
  #
  # For each route method in the controller, there
  # should be a resource, index should have  listing
  # of all entries, update should update and return
  # updated resource, new should return an empty object,
  # etc..
  class ResourceRouteBuilder
    # @param (see ResourceBuilder#initialize)
    def initialize(model, builder)
      @model = model
      @builder = builder
    end

    # Append methods to be build to the builder 
    # 
    # The methods to be added are resources related
    # to the routes:
    # - new
    # - show
    # - create
    # - update
    # - edit
    # - index
    #
    # @return [Array<Sinclair::MethodDefinition>]
    def append
      add_new_reource
      add_create_resource
      add_update_resource

      add_method(:index_resource,  model.plural)
      add_method(:edit_resource,   name)
      add_method(:show_resource,   name)
    end

    private

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

    delegate :add_method, to: :builder
    # @api private
    # @method add_method
    #
    # Add a method to be build on the controller
    #
    # @return [Array<Sinclair::MethodDefinition>]

    delegate :name, :klass, to: :model
    # @method name
    # @api private
    #
    # Returns the name of the resource represented by the model
    #
    # @return [String]
    
    # @method klass
    # @api private
    #
    # Resource class (real model class)
    #
    # @return [Class]

    # Adds the reource for new route
    #
    # It returns a new empty object
    #
    # @return [Array<Sinclair::MethodDefinition>]
    def add_new_reource
      add_method(:new_resource, "@new_resource ||= #{klass}.new")
    end

    # Adds the reource for create route
    #
    # It creates an entry in the database from the parameters
    #
    # @return [Array<Sinclair::MethodDefinition>]
    def add_create_resource
      add_method(
        :create_resource,
        "@create_resource ||= #{klass}.create(#{name}_params)"
      )
    end

    # Adds the reource for update route
    #
    # It updates an entry in the database from the parameters
    #
    # @return [Array<Sinclair::MethodDefinition>]
    def add_update_resource
      add_method(
        :update_resource,
        <<-CODE
          @update_resource ||= #{name}.tap do |value|
            value.update(#{name}_params)
          end
        CODE
      )
    end
  end
end
