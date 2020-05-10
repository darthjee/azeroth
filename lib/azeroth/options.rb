# frozen_string_literal: true

module Azeroth
  # @api private
  # @author Darthjee
  #
  # Resource buiilding options
  #
  # @see https://www.rubydoc.info/gems/sinclair/1.6.4/Sinclair/Options
  #   Sinclair::Options
  class Options < Sinclair::Options
    # Default options
    DEFAULT_OPTIONS = {
      only: %i[create destroy edit index new show update],
      except: [],
      decorator: true,
      before_save: nil
    }.freeze

    with_options DEFAULT_OPTIONS

    # Actions to be built
    #
    # @return [Array<Symbol>]
    def actions
      [only].flatten.map(&:to_sym) - [except].flatten.map(&:to_sym)
    end

    def event_dispatcher(event)
      return Event::Dispatcher.new unless event == :save
      Event::Dispatcher.new(before: before_save)
    end

    # @method only
    # @api private
    #
    # filter of only actions to be built
    #
    # @return [Array<String,Symbol>]

    # @method except
    # @api private
    #
    # actions to be ignored
    #
    # @return [Array<String,Symbol>]

    # @method decorator
    # @api private
    #
    # decorator class to be used
    #
    # when set as true/false, it either infer
    # the class (model_class::Decorator) or
    # do not use a decorator at all calling
    # model.as_json
    #
    # @return [Decorator,TrueClass,FalseClass]

    # @method before_save
    # @api private
    #
    # block or method name to be run
    # before committing changes in models
    # to database.
  end
end
