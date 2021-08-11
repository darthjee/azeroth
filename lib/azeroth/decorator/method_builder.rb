# frozen_string_literal: true

require 'sinclair'

module Azeroth
  class Decorator
    # Responsible for building readers for attributes
    # @api private
    class MethodBuilder < Sinclair
      # Builds reader
      #
      # reaader delegate method calls to @object
      #
      # @return [Array<Sinclair::MethodDefinition>]
      def self.build_reader(klass, attribute)
        new(klass).build_reader(attribute)
      end

      # (see MethodBuilder.build_reader)
      def build_reader(attribute)
        add_method(attribute, "@object.#{attribute}")
        build
      end
    end
  end
end
