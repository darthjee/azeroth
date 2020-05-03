# frozen_string_literal: true

module Azeroth
  # @api private
  # @author Darthjee
  #
  # Resource buiilding options
  class Options < Sinclair::Options
    # Default options
    DEFAULT_OPTIONS = {
      only: %i[create destroy edit index new show update],
      except: [],
      decorator: true
    }.freeze

    with_options DEFAULT_OPTIONS

    # Actions to be built
    #
    # @return [Array<Symbol>]
    def actions
      [only].flatten.map(&:to_sym) - [except].flatten.map(&:to_sym)
    end
  end
end
