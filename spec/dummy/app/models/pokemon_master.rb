# frozen_string_literal: true

class PokemonMaster < ActiveRecord::Base
  has_one :favorite_pokemon, -> { where(favorite: true) },
          class_name: 'Pokemon'
  has_many :pokemons
end
