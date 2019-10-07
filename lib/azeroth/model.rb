# frozen_string_literal: true

module Azeroth
  # @api private
  # @author Darthjee
  #
  # Model responsible for making the conection to the resource model class
  class Model
    attr_reader :name
    # @api private
    # @method name
    #
    # Returns the name of the resource represented by the model
    #
    # @return [String]

    # @param name [String,Symbol] name of the resource
    def initialize(name)
      @name = name.to_s
    end

    # resource class (real model class)
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
  end
end
