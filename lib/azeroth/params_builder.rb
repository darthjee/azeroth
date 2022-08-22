# frozen_string_literal: true

module Azeroth
  # @api private
  # @author Darthjee
  class ParamsBuilder
    # @param model [Model] resource interface
    # @param builder [Sinclair] methods builder
    def initialize(model, builder)
      @model = model
      @builder = builder
    end

    # Append the params methods to be built
    #
    # @return [Array<Sinclair::MethodDefinition>]
    def append
      method_name = name
      allowed_attributes = permitted_attributes.map(&:to_sym)

      add_method("#{name}_id") { params.require(:id) }
      add_method("#{name}_params") do
        params.require(method_name)
              .permit(*allowed_attributes)
      end
    end

    attr_reader :model, :builder
    # @method model
    # @api private
    # @private
    #
    # Resource interface
    #
    # @return [Model]

    # @method builder
    # @api private
    # @private
    #
    # Methods builder
    #
    # @return [Sinclair]

    delegate :add_method, to: :builder
    # @method add_method
    # @api private
    # @private
    #
    # Appends a method
    #
    # @return [Array<Sinclair::MethodDefinition>]

    delegate :name, :klass, to: :model
    # @method name
    # @api private
    # @private
    #
    # Resource name
    #
    # @return [Symbol,String]

    # @method klass
    # @api private
    # @private
    #
    # Controller to be changed
    #
    # @return [Array<Sinclair::MethodDefinition>]

    # Returns all updatable attributes
    #
    # @return [Array<String>]
    def permitted_attributes
      @permitted_attributes ||= klass.attribute_names - ['id']
    end
  end
end
