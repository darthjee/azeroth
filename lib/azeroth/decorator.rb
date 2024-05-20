# frozen_string_literal: true

require 'sinclair'

module Azeroth
  # @api public
  #
  # Class to be used when decorating outputs
  #
  # @example
  #   class DummyModel
  #     include ActiveModel::Model
  #
  #     attr_accessor :id, :first_name, :last_name, :age,
  #                   :favorite_pokemon
  #
  #     class Decorator < Azeroth::Decorator
  #       expose :name
  #       expose :age
  #       expose :favorite_pokemon, as: :pokemon
  #
  #       def name
  #         [object.first_name, object.last_name].join(' ')
  #       end
  #     end
  #   end
  #
  #   model = DummyModel.new(
  #     id: 100,
  #     first_name: 'John',
  #     last_name: 'Wick',
  #     favorite_pokemon: 'Arcanine'
  #   )
  #
  #   decorator = DummyModel::Decorator.new(model)
  #
  #   decorator.as_json # returns {
  #                     #   'name'    => 'John Wick',
  #                     #   'age'     => nil,
  #                     #   'pokemon' => 'Arcanine'
  #                     # }
  class Decorator
    autoload :ClassMethods,      'azeroth/decorator/class_methods'
    autoload :HashBuilder,       'azeroth/decorator/hash_builder'
    autoload :KeyValueExtractor, 'azeroth/decorator/key_value_extractor'
    autoload :MethodBuilder,     'azeroth/decorator/method_builder'
    autoload :Options,           'azeroth/decorator/options'

    extend ClassMethods

    # @api private
    #
    # @overload initialize(object)
    #   @param [Object] object to be decorated
    # @overload initialize(array)
    #   @param array [Array] array of objects to be decorated
    def initialize(object)
      @object = object
    end

    # @api private
    #
    # Builds hash / Json from the given object
    #
    # When object is an iterator, decoration is applied to each
    # and an array is returned
    #
    # @param args [Hash] options (to be implemented)
    #
    # @return [Hash]
    def as_json(*args)
      return nil if object.nil?

      return array_as_json(*args) if enum?

      HashBuilder.new(self).as_json
    end

    private

    attr_reader :object
    # @method object
    # @api private
    #
    # Object to be decorated
    #
    # @return [Object]

    # @api private
    # @private
    #
    # Checks if object is an enumerable
    #
    # @return [TrueClass,FalseClass]
    def enum?
      object.is_a?(Enumerable)
    end

    # @api private
    # @private
    #
    # Iterate over enumerable decorating each entry
    #
    # @return [Array<Hash>]
    def array_as_json(*args)
      object.map do |item|
        self.class.new(item).as_json(*args)
      end
    end

    # @api private
    # @private
    # Method called when method is missing
    #
    # This delegates method calls to the given object
    #
    # @param method_name [Symbol] name of the method
    #   called
    # @param args [Array<Object>] arguments of the
    #   method called
    #
    # @return [Object]
    def method_missing(method_name, *args)
      if object.respond_to?(method_name)
        object.public_send(method_name, *args)
      else
        super
      end
    end

    # @api private
    # @private
    # Checks if it would respond to a method
    #
    # The decision is delegated to the object
    #
    # @param method_name [Symbol] name of the method checked
    # @param include_private [TrueClass,FalseClass] flag
    #   indicating if private methods should be included
    #
    # @return [TrueClass,FalseClass]
    def respond_to_missing?(method_name, include_private)
      object.respond_to?(method_name, include_private)
    end
  end
end
