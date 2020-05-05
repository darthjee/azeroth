# frozen_string_literal: true

require 'sinclair'

module Azeroth
  # @api private
  # @author Darthjee
  #
  # Decorator that calls #as_json on object
  class DummyDecorator
    delegate :as_json, to: :@object
    # @method as_json
    # @api public
    #
    # Returns object.as_json
    #
    # @return [Hash]

    # @param object [Object] object to be decorated
    def initialize(object)
      @object = object
    end
  end
end
