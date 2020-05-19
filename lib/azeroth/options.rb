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
    #
    # @api public
    #
    # @see Resourceable::ClassMethods#resource_for
    DEFAULT_OPTIONS = {
      only: %i[create destroy edit index new show update],
      except: [],
      decorator: true,
      before_save: nil,
      build_with: nil
    }.freeze

    with_options DEFAULT_OPTIONS

    # Actions to be built
    #
    # @return [Array<Symbol>]
    def actions
      [only].flatten.map(&:to_sym) - [except].flatten.map(&:to_sym)
    end

    # Returns event dispatcher
    #
    # Event dispatcher is responsible for
    # sending events such as +before_save+
    # to it's correct calling point
    #
    # @return [Jace::Dispatcher]
    def event_dispatcher(event)
      Jace::Dispatcher.new(
        before: try("before_#{event}")
      )
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
    # Block or method name to be run before save
    #
    # The given method or block will be ran
    # before committing changes in models
    # to database
    #
    # @return [Symbol,Proc]
  end
end
