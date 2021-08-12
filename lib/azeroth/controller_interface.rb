# frozen_string_literal: true

module Azeroth
  class ControllerInterface
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

    # render response json
    #
    # @return [String]
    def render_json(json, status)
      controller.instance_eval do
        render(json: json, status: status)
      end
    end

    def set(variable, value)
      controller.instance_variable_set("@#{variable}", value)
    end

    private

    attr_reader :controller

    def method_missing(method_name, *args)
      if controller.respond_to?(method_name, true)
        controller.send(method_name, *args)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private)
      controller.respond_to?(method_name, include_private)
    end
  end
end
