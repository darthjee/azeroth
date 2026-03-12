# frozen_string_literal: true

class PokemonMaster < ActiveRecord::Base
  has_one :favorite_pokemon, -> { where(favorite: true) },
          class_name: 'Pokemon',
          inverse_of: :pokemon_master,
          dependent: :destroy
  has_many :pokemons, dependent: :destroy, inverse_of: :pokemon_master
end
