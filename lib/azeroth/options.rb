# frozen_string_literal: true

module Azeroth
  # @api private
  # @author Darthjee
  #
  # Resource buiilding options
  class Options < ::OpenStruct
    DEFAULT_OPTIONS = {
      only: %i[create destroy edit index new show update],
      except: []
    }.freeze

    # @param options [Hash] hash with options
    # @option options only [Array<Symbol,String>] List of
    #   actions to be built
    # @option options except [Array<Symbol,String>] List of
    #   actions to not to be built
    def initialize(options = {})
      super(DEFAULT_OPTIONS.merge(options))
    end

    # Actions to be built
    #
    # @return [Array<Symbol>]
    def actions
      [only].flatten.map(&:to_sym) - [except].flatten.map(&:to_sym)
    end
  end
end
