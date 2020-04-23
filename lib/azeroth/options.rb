# frozen_string_literal: true

module Azeroth
  class Options < ::OpenStruct
    DEFAULT_OPTIONS = {
      only: %i[create destroy edit index new show update],
      except: []
    }.freeze

    def initialize(options = {})
      super(DEFAULT_OPTIONS.merge(options))
    end

    def actions
      only.map(&:to_sym) - except.map(&:to_sym)
    end
  end
end
