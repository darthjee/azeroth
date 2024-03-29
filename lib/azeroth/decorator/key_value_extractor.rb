# frozen_string_literal: true

module Azeroth
  class Decorator
    # @api private
    #
    # Class responsible to extract the value for an attribute
    #
    # The value is extracted by sending a method
    # call to the decorator
    #
    # A decorator is infered for the value / attribute
    # or used from the options given
    class KeyValueExtractor < Sinclair::Model
      initialize_with(:decorator, :attribute, :options)
      # @param decorator [Decorator] decorator object
      # @param attribute [Symbol] attribute to be used on output hash
      # @param options [Decorator::Options] decoration options
      # @option options if [Proc,Symbol] conditional to be
      #   checked when exposing field
      #   (see {Decorator::Options#if})

      # Return hash for attribute
      #
      # @return [Hash] hash in the format
      #   +{ attribute => decorated_value }+
      def as_json
        return {} unless add_attribute?

        key = options.as || attribute

        {
          key.to_s => json_value
        }
      end

      private

      # @method decorator
      # @api private
      # @private
      #
      # decorator with object to be decorated
      #
      # @return [Decorator]

      # @method attribute
      # @api private
      # @private
      #
      # attribute to be exposed
      #
      # @return [Symbol]

      # @method options
      # @api private
      # @private
      #
      # exposing options
      #
      # @return [Decorator::Options]

      # @private
      #
      # returns the value ready to be transformed into json
      #
      # @return [Object]
      def json_value
        decorator_class(value).new(value).as_json
      end

      # @private
      # Retruns the value extracted from decorator
      #
      # @return [Object]
      def value
        @value ||= decorator.public_send(attribute)
      end

      # @private
      #
      # Finds the correct decorator class for a value
      #
      # @return [Class<Decorator>]
      def decorator_class(object)
        decorator_from_options || decorator_class_for(object)
      end

      # @private
      #
      # returns decorator defined in options
      #
      # @return [Class<Decorator>, NilClass]
      def decorator_from_options
        return options.decorator if options.decorator_defined?

        Azeroth::DummyDecorator unless options.decorator
      end

      # @private
      #
      # Finds the correct decorator class for a value
      #
      # @return [Class<Decorator>]
      def decorator_class_for(object)
        return object.class::Decorator unless object.is_a?(Enumerable)

        decorator_class_for(object.first)
      rescue NameError
        Azeroth::DummyDecorator
      end

      # @private
      #
      # Check if an attribute should be added to the hash
      #
      # @return [Object] result of method call from decorator
      def add_attribute?
        conditional = options.if
        return true unless conditional.present?

        block = proc(&conditional)

        block.call(decorator)
      end
    end
  end
end
