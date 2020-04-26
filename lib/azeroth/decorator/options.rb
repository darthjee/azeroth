# frozen_string_literal: true

module Azeroth
  class Decorator
    class Options < ::OpenStruct
      DEFAULT_OPTIONS = {
        as: nil,
        if: nil
      }.freeze

      def initialize(options = {})
        check_options(options)

        super(DEFAULT_OPTIONS.merge(options))
      end

      private

      def check_options(options)
        invalid_keys = options.keys - DEFAULT_OPTIONS.keys

        return if invalid_keys.empty?

        raise Azeroth::Exception::InvalidOptions, invalid_keys
      end
    end
  end
end
