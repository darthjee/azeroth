# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::Decorator do
  describe 'readme' do
    it 'decorates model' do
      master = PokemonMaster.create(
        first_name: 'Ash',
        last_name: 'Ketchum',
        age: 10
      )

      master.create_favorite_pokemon(
        name: 'pikachu',
        nickname: 'Pikachu'
      )

      metapod = Pokemon.create(name: :metapod)

      master.pokemons.create(
        name: 'butterfree', previous_form: metapod
      )
      master.pokemons.create(name: 'squirtle')

      decorator = PokemonMaster::Decorator.new(master)

      expect(decorator.as_json).to eq(
        {
          'age' => 10,
          'name' => 'Ash Ketchum',
          'favorite_pokemon' => {
            'name' => 'pikachu',
            'nickname' => 'Pikachu'
          },
          'pokemons' => [{
            'name' => 'butterfree',
            'evolution_of' => 'metapod'
          }, {
            'name' => 'squirtle'
          }, {
            'name' => 'pikachu'
          }]
        }
      )
    end
  end
end
