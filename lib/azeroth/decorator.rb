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
    autoload :HashBuilder, 'azeroth/decorator/hash_builder'

    class << self
      # @api private
      #
      # All attributes exposed
      #
      # @return [Array<Symbol>]
      def attributes_map
        @attributes_map ||= {}
      end

      private

      # @visibility public
      # @api public
      # @private
      #
      # Expose attributes on json decorated
      #
      # @param attribute [Symbol,String] attribute to be exposed
      # @param as [Symbol,String] name of the attribute on the json
      #
      # @return [Array<Symbol>]
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
      def expose(attribute, **options)
        builder = Sinclair.new(self)
        builder.add_method(attribute, "@object.#{attribute}")
        builder.build

        attributes_map[attribute] = options
      end
      # rubocop:enable Naming/UncommunicativeMethodParamName
    end

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
    # @param *args [Hash] options (to be implemented)
    #
    # @return [Hash]
    def as_json(*args)
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
  end
end
