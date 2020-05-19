# frozen_string_literal: true

module Azeroth
  # @api private
  # @author Darthjee
  #
  # Model responsible for making the conection to the resource model class
  class Model
    # @param name [String,Symbol] name of the resource
    # @param options [Azeroth::Options] resource options
    def initialize(name, options)
      if name.is_a?(Class)
        @klass = name
      else
        @name = name.to_s
      end

      @options = options
    end

    # Returns the name of the resource represented by the model
    #
    # @return [String]
    def name
      @name ||= klass.name.gsub(/.*::/, '').underscore
    end

    # Resource class (real model class)
    #
    # @return [Class]
    def klass
      @klass ||= name.camelize.constantize
    end

    # Return the pluralized version of resource name
    #
    # @return [String]
    def plural
      name.pluralize
    end

    # Decorates object to return a hash
    #
    # Decorate uses klass::Decorator to decorate.
    #
    # When no decorator has been defined, object will
    # receive an +#as_json+ call instead
    #
    # @return [Hash]
    def decorate(object)
      decorator_class.new(object).as_json
    end

    private

    attr_reader :options
    # @method options
    # @api private
    # @private
    #
    # Returns options
    #
    # @return [Azeroth::Options]

    delegate :decorator, to: :options

    # @private
    #
    # Returns decorator class for the object
    #
    # @return [Class] subclass of {Decorator}
    def decorator_class
      @decorator_class ||= calculate_decorator_class
    end

    # @private
    #
    # Calculates decorator class
    #
    # When options.decorator is false return DummyDecorator
    #
    # when options.decorator is a class, returns it
    #
    # When finding the decorator from the model fails,
    # returns DummyDecorator
    #
    # @return [Azeroth::Decorator,DummyDecorator]
    def calculate_decorator_class
      return DummyDecorator unless options.decorator
      return decorator if decorator.is_a?(Class)

      klass::Decorator
    rescue NameError
      DummyDecorator
    end
  end
end
