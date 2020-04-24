# frozen_string_literal: true

module Azeroth
  # @api private
  # @author Darthjee
  #
  # Excaptions raised by azeroth
  class Exception < ::StandardError
    # @api private
    # @author Darthjee
    #
    # Exception raised when invalid options are given
    #
    # @example Usage
    #   exception = Azeroth::Exception::InvalidOptions.new(%i[invalid options])
    #   exception.message
    #   # return 'Invalid keys on options initialization (invalid options)'
    class InvalidOptions < Azeroth::Exception
      # @param invalid_keys [Array<Symbol>] list of invalid keys
      def initialize(invalid_keys = [])
        @invalid_keys = invalid_keys
      end

      # Exception string showing invalid keys
      #
      # @return [String]
      #
      # @example (see InvalidOptions)
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
