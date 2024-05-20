# frozen_string_literal: true

module Azeroth
  class Decorator
    # @api private
    # @author Darthjee
    #
    # Resource buiilding options for decorator
    #
    # @see https://www.rubydoc.info/gems/sinclair/1.6.4/Sinclair/Options
    #   Sinclair::Options
    class Options < Sinclair::Options
      DEFAULT_OPTIONS = {
        as: nil,
        if: nil,
        decorator: true,
        override: true,
        reader: true,
      }.freeze

      with_options DEFAULT_OPTIONS

      # @method as
      # @api private
      #
      # key to use when exposing the field
      #
      # when nil, the name of the field
      #
      # @return [Symbol,String]

      # @method if
      # @api private
      #
      # conditional to be checked when exposing field
      #
      # when conditional returns false, the
      # field will not be exposed
      #
      # when if is a Proc the proc will be used,
      # when it is a Symbol or String this will be
      # the name of the method called in the decorator
      # to evaluate the condition
      #
      # @return [Proc,Symbol]

      # @method decorator
      # @api private
      #
      # Decorator class to decorate the value
      #
      # when false {DummyDecorator} will be used
      #
      # when nil, a decorator will be infered from
      # value::Decorator
      #
      # @return [NilClass,Decorator]

      # @api private
      #
      # Returns true when attribute must can be decorated
      #
      # when false, decoration happens through
      # #as_json call on value
      #
      # @return [TrueClass,FalseClass]
      def decorator_defined?
        decorator.is_a?(Class)
      end
    end
  end
end
