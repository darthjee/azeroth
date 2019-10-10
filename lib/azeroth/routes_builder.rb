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
      %i[index show new edit create update].each do |route|
        add_method(route, 'render_basic')
      end

      add_method(:destroy, destroy_code)
    end

    private

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

    # @private
    #
    # Method code to destrou route
    #
    # @return [String]
    def destroy_code
      <<-RUBY
        #{model.name}.destroy
        head :no_content
      RUBY
    end
  end
end
