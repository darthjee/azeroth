# frozen_string_literal: true

module Azeroth
  class Decorator
    class << self
      def attributes
        @attributes ||= []
      end

      private

      # rubocop:disable Naming/UncommunicativeMethodParamName
      def expose(attribute, as: attribute)
        builder = Sinclair.new(self)
        builder.add_method(as, "@object.#{attribute}")
        builder.build

        attributes << as
      end
      # rubocop:enable Naming/UncommunicativeMethodParamName
    end

    def initialize(object)
      @object = object
    end

    def as_json(*args)
      return array_as_json(*args) if enum?

      {}.tap do |hash|
        self.class.attributes.each do |method|
          hash[method.to_s] = public_send(method)
        end
      end
    end

    private

    attr_reader :object

    def enum?
      object.is_a?(Enumerable)
    end

    def array_as_json(*args)
      object.map do |item|
        self.class.new(item).as_json(*args)
      end
    end
  end
end
