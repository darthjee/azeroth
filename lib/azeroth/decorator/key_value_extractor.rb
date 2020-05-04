# frozen_string_literal: true

require 'sinclair'

module Azeroth
  class Decorator
    class KeyValueExtractor
      def initialize(decorator, key, options)
        @decorator = decorator
        @key = key
        @options = options
      end

      def as_json
        return {} unless add_attribute?

        final_key = options.as || key

        {
          final_key.to_s => json_value
        }
      end

      private
      
      attr_reader :decorator, :key, :options

      def json_value
        decorator_class_for(value).new(value).as_json
      end

      def value
        @value ||= decorator.public_send(key)
      end

      def decorator_class_for(object)
        return options.decorator if options.decorator
        return object.class::Decorator unless object.is_a?(Enumerable)

        decorator_class_for(object.first)
      rescue NameError
        Azeroth::DummyDecorator
      end

      # @private
      #
      # Check if an attribute should be added to the hash
      #
      # @option options if [Symbol,Proc] method/block to be called
      #   checking if an attribute should or should not
      #   be exposed
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
