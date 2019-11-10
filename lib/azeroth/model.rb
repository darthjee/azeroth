# frozen_string_literal: true

module Azeroth
  # @api private
  # @author Darthjee
  #
  # Model responsible for making the conection to the resource model class
  class Model
    attr_reader :name
    # @method name
    # @api private
    #
    # Returns the name of the resource represented by the model
    #
    # @return [String]

    # @param name [String,Symbol] name of the resource
    def initialize(name)
      @name = name.to_s
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

    def decorate(object)
      decorator.new(object).as_json
    end

    private

    def decorator
      @decorator ||= klass::Decorator
    rescue NameError
      @decorator = build_decorator
    end

    def build_decorator
      clazz = klass

      Class.new(Azeroth::Decorator) do
        clazz.new.attributes.keys.each do |attribute|
          expose attribute
        end
      end
    end
  end
end
