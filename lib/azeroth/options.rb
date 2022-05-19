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
      after_save: nil,
      build_with: nil,
      update_with: nil,
      paginated: false,
      per_page: 20
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
        before: try("before_#{event}"),
        after: try("after_#{event}")
      )
    end

    alias paginated? paginated
    # @method paginated?
    # @api private
    #
    # @see paginated
    # @return [TrueClass,FalseClass]

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

    # @method after_save
    # @api private
    #
    # Block or method name to be run after save
    #
    # The given method or block will be ran
    # after committing changes in models
    # to database
    #
    # @return [Symbol,Proc]

    # @method build_with
    # @api private
    #
    # Block or method name to be ran when building the resource
    #
    # @return [Symbol,Proc]

    # @method update_with
    # @api private
    #
    # Block or method name to be ran when updating the resource
    #
    # @return [Symbol,Proc]

    # @method paginated
    # @api private
    #
    # Boolean indicating if pagination should or not be used
    #
    # @return [TrueClass,FalseClass]

    # @method per_page
    # @api private
    #
    # Number of elements when pagination is active
    #
    # @return [Integer]
  end
end
