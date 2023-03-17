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
        attributes_map.inject({}) do |hash, (method, options)|
          new_hash = KeyValueExtractor.new(
            decorator: decorator, attribute: method, options: options
          ).as_json
          hash.merge!(new_hash)
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

      # attributes to be built to hash
      #
      # The keys are the methods to be called and
      # the values are the exposing options
      #
      # @return [Hash] hash of pairs method,options
      def attributes_map
        decorator.class.attributes_map
      end
    end
  end
end
