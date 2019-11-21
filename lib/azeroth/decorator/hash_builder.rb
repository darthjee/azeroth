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
        {}.tap do |hash|
          attributes_map.each do |method, options|
            next unless add_attribute?(options)

            key = options[:as] || method

            hash[key.to_s] = decorator.public_send(method)
          end
        end
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

      # Check if an attribute should be added to the hash
      def add_attribute?(options)
        conditional = options[:if]
        return true unless conditional.present?

        # TODO: delegate method missing to object
        decorator.send(:object).public_send(conditional)
      end

      def attributes_map
        decorator.class.attributes_map
      end
    end
  end
end
