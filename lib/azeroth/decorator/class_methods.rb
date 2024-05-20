# frozen_string_literal: true

module Azeroth
  class Decorator
    module ClassMethods
      # @api private
      #
      # All attributes exposed
      #
      # @return [Hash<Symbol,Hash>]
      def attributes_map
        @attributes_map ||= build_attributes_map
      end

      private

      # @api private
      # @private
      #
      # Initialize attributes to be exposed map
      #
      # When the class inherity from another
      # decorator, the new class should expose the
      # same attributes.
      #
      # @return [Hash<Symbol,Hash>]
      def build_attributes_map
        superclass.try(:attributes_map).dup || {}
      end

      # @visibility public
      # @api public
      # @private
      #
      # Expose attributes on json decorated
      #
      # @param attribute [Symbol,String] attribute to be exposed
      # @param options_hash [Hash] exposing options
      # @option options_hash as [Symbol,String] custom key
      #   to expose
      # @option options_hash if [Symbol,Proc] method/block
      #   to be called
      #   checking if an attribute should or should not
      #   be exposed
      # @option options_hash decorator [FalseClass,TrueClass,Class]
      #   flag to use or not a decorator or decorator class to be used
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
      #
      # @example With relations
      #   # pokemon/decorator.rb
      #
      #   class Pokemon::Decorator < Azeroth::Decorator
      #     expose :name
      #     expose :previous_form_name, as: :evolution_of, if: :evolution?
      #
      #     def evolution?
      #       previous_form
      #     end
      #
      #     def previous_form_name
      #       previous_form.name
      #     end
      #   end
      #
      #   # pokemon/favorite_decorator.rb
      #
      #   class Pokemon::FavoriteDecorator < Pokemon::Decorator
      #     expose :nickname
      #   end
      #
      #   # pokemon_master/decorator.rb
      #
      #   class PokemonMaster < ActiveRecord::Base
      #     has_one :favorite_pokemon, -> { where(favorite: true) },
      #             class_name: 'Pokemon'
      #     has_many :pokemons
      #   end
      #
      #   # pokemon.rb
      #
      #   class Pokemon < ActiveRecord::Base
      #     belongs_to :pokemon_master
      #     has_one :previous_form,
      #             class_name: 'Pokemon',
      #             foreign_key: :previous_form_id
      #   end
      #
      #   # pokemon_master.rb
      #
      #   class PokemonMaster::Decorator < Azeroth::Decorator
      #     expose :name
      #     expose :age
      #     expose :favorite_pokemon, decorator: Pokemon::FavoriteDecorator
      #     expose :pokemons
      #
      #     def name
      #       [
      #         first_name,
      #         last_name
      #       ].compact.join(' ')
      #     end
      #   end
      #
      #   # schema.rb
      #
      #   ActiveRecord::Schema.define do
      #     self.verbose = false
      #
      #      create_table :pokemon_masters, force: true do |t|
      #       t.string :first_name, null: false
      #       t.string :last_name
      #       t.integer :age, null: false
      #     end
      #
      #     create_table :pokemons, force: true do |t|
      #       t.string :name, null: false
      #       t.string :nickname
      #       t.integer :pokemon_master_id
      #       t.boolean :favorite
      #       t.integer :previous_form_id
      #       t.index %i[pokemon_master_id favorite], unique: true
      #     end
      #
      #     add_foreign_key 'pokemons', 'pokemon_masters'
      #   end
      #
      #   # test.rb
      #
      #   master = PokemonMaster.create(
      #     first_name: 'Ash',
      #     last_name: 'Ketchum',
      #     age: 10
      #   )
      #
      #   master.create_favorite_pokemon(
      #     name: 'pikachu',
      #     nickname: 'Pikachu'
      #   )
      #
      #   metapod = Pokemon.create(name: :metapod)
      #
      #   master.pokemons.create(
      #     name: 'butterfree', previous_form: metapod
      #   )
      #   master.pokemons.create(name: 'squirtle')
      #
      #   decorator = PokemonMaster::Decorator.new(master)
      #
      #   decorator.as_json
      #   # returns
      #   # {
      #   #   'age' => 10,
      #   #   'name' => 'Ash Ketchum',
      #   #   'favorite_pokemon' => {
      #   #     'name' => 'pikachu',
      #   #     'nickname' => 'Pikachu'
      #   #   },
      #   #   'pokemons' => [{
      #   #     'name' => 'butterfree',
      #   #     'evolution_of' => 'metapod'
      #   #   }, {
      #   #     'name' => 'squirtle'
      #   #   }, {
      #   #     'name' => 'pikachu'
      #   #   }]
      #   # }
      def expose(attribute, **options_hash)
        options = Decorator::Options.new(options_hash)

        MethodBuilder.build_reader(self, attribute, options)

        attributes_map[attribute] = options
      end
    end
  end
end
