# frozen_string_literal: true

require 'sinclair'

module Azeroth
  class Decorator
    # @api private
    #
    # Class responsible for building the hash on
    # Decorator#as_json calls
    class HashBuilder
      # @param decorator [Decorator] decorator that
      #   will receive all method calls
      def initialize(decorator)
        @decorator = decorator
      end

      # Build hash as defined by decorator
      #
      # The built of the hash keys is defined
      # by decorator attributes and method calls
      # to the same decorator that will then delgate,
      # when needed, to its object
      #
      # @return [Hash]
      def as_json
        attributes_map.each do |method, options|
          add_attribute(method, options)
        end
        hash
      end

      private

      attr_reader :decorator
      # @method decorator
      # @api private
      # @private
      #
      # decorator with object to be decorated
      #
      # @return [Decorator]

      # Adds an attribute to the exposed hash
      #
      # @param method [Symbol,String] method to be called
      #   from the decorator
      # @param options [Hash] exposing options
      # @option options as [Symbol,String] custom key
      #   to expose
      # @option options if [Symbol,Proc] method/block to be called
      #   checking if an attribute should or should not
      #   be exposed
      #
      # @return [Object] result of method call from decorator
      def add_attribute(method, options)
        return unless add_attribute?(options)

        key = options.as || method

        hash[key.to_s] = json_for(method, options)
      end

      def json_for(method, options)
        value = decorator.public_send(method)

        decorator_class_for(value, options).new(value).as_json
      end

      def decorator_class_for(value, options)
        return options.decorator if options.decorator
        return value.class::Decorator unless value.is_a?(Enumerable)

        decorator_class_for(value.first, options)
      rescue NameError
        Azeroth::DummyDecorator
      end

      # Check if an attribute should be added to the hash
      #
      # @param options [Hash] exposing options
      # @option options if [Symbol,Proc] method/block to be called
      #   checking if an attribute should or should not
      #   be exposed
      #
      # @return [Object] result of method call from decorator
      def add_attribute?(options)
        conditional = options.if
        return true unless conditional.present?

        block = proc(&conditional)

        block.call(decorator)
      end

      # attributes to be built to hash
      #
      # The keys are the methods to be called and
      # the values are the exposing options
      #
      # @return [Hash] hash of pairs method,options
      def attributes_map
        decorator.class.attributes_map
      end

      # Hash being built
      #
      # @return [Hash]
      def hash
        @hash ||= {}
      end
    end
  end
end
