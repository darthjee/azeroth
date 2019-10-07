# frozen_string_literal: true

module Azeroth
  class Options < ::OpenStruct
    DEFAULT_OPTIONS = {
    }.freeze

    def initialize(options)
      super(DEFAULT_OPTIONS.merge(options))
    end
  end
end
