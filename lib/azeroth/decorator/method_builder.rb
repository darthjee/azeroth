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
          self.new(klass, options).build_reader(attribute)
        end
      end

      def initialize(klass, options)
        super(klass)
        @options = options
      end

      # (see MethodBuilder.build_reader)
      def build_reader(attribute)
        add_method(attribute, "@object.#{attribute}")
        build
      end
    end
  end
end
