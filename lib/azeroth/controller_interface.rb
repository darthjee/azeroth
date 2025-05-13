# frozen_string_literal: true

module Azeroth
  # @api private
  #
  # Interface for using the controller
  class ControllerInterface
    # @param controller [ApplicationController]
    def initialize(controller)
      @controller = controller
    end

    # Set response headers
    #
    # @param headers_hash [Hash] headers to be set
    #
    # @return [Hash]
    def add_headers(headers_hash)
      controller.instance_eval do
        headers_hash.each do |key, value|
          headers[key.to_s] = value
        end
      end
    end

    # Renders response json
    #
    # @return [String]
    def render_json(json, status)
      controller.instance_eval do
        render(json: json, status: status)
      end
    end

    # Set a variable in the controller
    #
    # @param variable [String,Symbol] variable name
    # @param value [Object] value to be set
    #
    # @return [Object]
    def set(variable, value)
      controller.instance_variable_set("@#{variable}", value)
    end

    # Forces a controller to run a block
    #
    # When the block is a +Proc+ that is evaluated,
    # when it is a +Symbol+ or +String+, a method is called
    #
    # @return [Object] whatever the block returns
    def run(block)
      case block
      when Proc
        controller.instance_eval(&block)
      else
        controller.send(block)
      end
    end

    private

    attr_reader :controller

    # @method controller
    # @private
    # @api private
    #
    # Controller where methods will be called
    #
    # @return [ApplicationController]

    # @private
    #
    # Dispatcher to delegate all methods call to controller
    #
    # @param method_name [Symbol] name of the method
    #   called
    #
    # @return [Object]
    def method_missing(method_name, *)
      if controller.respond_to?(method_name, true)
        controller.send(method_name, *)
      else
        super
      end
    end

    # @private
    #
    # Checks if a controller responds to a method
    #
    # @param method_name [Symbol] name of the method checked
    # @param include_private [TrueClass,FalseClass] flag
    #   indicating if private methods should be included
    #
    # @return [TrueClass,FalseClass]
    def respond_to_missing?(method_name, include_private)
      controller.respond_to?(method_name, include_private)
    end
  end
end
