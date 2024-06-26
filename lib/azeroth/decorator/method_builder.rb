# frozen_string_literal: true

require 'sinclair'

module Azeroth
  class Decorator
    # Responsible for building readers for attributes
    # @api private
    class MethodBuilder < Sinclair
      class << self
        # Builds reader
        #
        # reaader delegate method calls to @object
        #
        # @return [Array<Sinclair::MethodDefinition>]
        def build_reader(klass, attribute, options)
          new(klass, options).build_reader(attribute)
        end
      end

      def initialize(klass, options)
        super(klass)
        @options = options
      end

      # (see MethodBuilder.build_reader)
      def build_reader(attribute)
        return if skip_creation?(attribute)

        add_method(attribute, "@object.#{attribute}")
        build
      end

      def skip_creation?(attribute)
        return true unless options.reader
        return false unless klass.method_defined?(attribute)

        !options.override
      end
    end
  end
end
