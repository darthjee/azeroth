# frozen_string_literal: true

module Azeroth
  class Decorator
    class Options < Sinclair::Options
      DEFAULT_OPTIONS = {
        as: nil,
        if: nil
      }.freeze

      with_options DEFAULT_OPTIONS
    end
  end
end
