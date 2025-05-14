# frozen_string_literal: true

module Azeroth
  # @api private
  # @author Darthjee
  #
  # Class responsible for adding params handling methods to a controller
  class ParamsBuilder < Sinclair::Model
    # @!method initialize(model:, builder:, options:)
    #   @api private
    #
    #   @param model [Model] Resource interface
    #   @param builder [Sinclair] Methods builder
    #   @param options [Azeroth::Options] options
    #
    #   @return [ParamsBuilder]
    initialize_with(:model, :builder, :options, writter: false)

    # Append the params methods to be built
    #
    # @return [Array<Sinclair::MethodDefinition>]
    def append
      method_name = name
      allowed_attributes = permitted_attributes.map(&:to_sym)

      param_key = options.param_key
      add_method("#{name}_id") { params.require(param_key) }
      add_method("#{name}_params") do
        params.require(method_name)
              .permit(*allowed_attributes)
      end
    end

    private

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

    # @method options
    # @api private
    # @private
    #
    # Methods builder
    #
    # @return [Azeroth::Options]

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
