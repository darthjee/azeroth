# frozen_string_literal: true

require 'sinclair'

module Azeroth
  class Decorator
    class HashBuilder
      attr_reader :decorator

      def initialize(decorator)
        @decorator = decorator
      end

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

      def add_attribute?(options)
        conditional = options[:if]
        return true unless conditional.present?
        #TODO: delegate method missing to object
        decorator.send(:object).public_send(conditional)
      end

      def attributes_map
        decorator.class.attributes_map
      end
    end
  end
end
