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
        decorator: nil
      }.freeze

      with_options DEFAULT_OPTIONS

      # @method as
      # @api private
      # @public
      #
      # key to use when exposing the field
      #
      # when nil, the name of the field
      #
      # @return [Symbol,String]

      # @method if
      # @api private
      # @public
      #
      # conditional to be checked when exposing field
      #
      # when conditional returns false, the
      # field will not be exposed
      #
      # when if is a {Proc} the proc will be used,
      # when it is a {Symbol} or {String} this will be
      # the name of the method called in the decorator
      # to evaluate the condition
    end
  end
end
