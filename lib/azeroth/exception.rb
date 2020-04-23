# frozen_string_literal: true

module Azeroth
  # @api public
  # @author Darthjee
  #
  # Excaptions raised by azeroth
  class Exception < ::StandardError
    # @api public
    # @author Darthjee
    #
    # Exception raised when invalid options are given
    class InvalidOptions < Azeroth::Exception
      # @param invalid_keys [Array<Symbol>] list of invalid keys
      def initialize(invalid_keys = [])
        @invalid_keys = invalid_keys
      end

      # Exception string showing invalid keys
      #
      # @return [String]
      def message
        keys = invalid_keys.join(' ')
        "Invalid keys on options initialization (#{keys})"
      end

      private

      attr_reader :invalid_keys
      # @method invalid_keys
      # @api private
      # @private
      #
      # invalid keys on options initialization
      #
      # @return [Array<Symbol>]
    end
  end
end
