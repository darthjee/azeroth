# frozen_string_literal: true

module Azeroth
  class Exception < ::StandardError
    class InvalidOptions < Azeroth::Exception
      def initialize(invalid_keys = [])
        @invalid_keys = invalid_keys
      end

      def message
        keys = invalid_keys.join(' ')
        "Invalid keys on options initialization (#{keys})"
      end

      private

      attr_reader :invalid_keys
    end
  end
end
