# frozen_string_literal: true

describe Azeroth::Decorator do
  describe 'yard' do
    describe '#as_json' do
      it 'simple example' do
        object = DummyModel.new(
          id: 100,
          first_name: 'John',
          last_name: 'Wick',
          favorite_pokemon: 'Arcanine'
        )

        decorator = DummyModel::Decorator.new(object)

        expect(decorator.as_json).to eq(
          'name' => 'John Wick',
          'age' => nil,
          'pokemon' => 'Arcanine'
        )
      end

      it 'complete example' do
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
end
