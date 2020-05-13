# frozen_string_literal: true

module Azeroth
  # @api private
  # @author Darthjee
  #
  # Builder resposible for adding routes methods to the controller
  class RoutesBuilder
    # @param model [Model] resource interface
    # @param builder [Sinclair] methods builder
    # @param options [Option]
    def initialize(model, builder, options)
      @model = model
      @builder = builder
      @options = options
    end

    # Append the routes methods to be built
    #
    # @return [Array<Sinclair::MethodDefinition>]
    def append
      options.actions.each do |route|
        add_method(route, &route_code(route))
      end
    end

    private

    attr_reader :model, :builder, :options
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
    # Buiding options
    #
    # @return [Options]

    delegate :add_method, to: :builder
    # @method add_method
    # @api private
    # @private
    #
    # Appends a method
    #
    # @return [Array<Sinclair::MethodDefinition>]

    def route_code(route)
      model_interface = model
      options_object = options
      handler_class = Azeroth::RequestHandler.const_get(
        route.to_s.capitalize
      )

      proc do
        handler_class.new(
          self, model_interface, options_object
        ).process
      end
    end
  end
end
