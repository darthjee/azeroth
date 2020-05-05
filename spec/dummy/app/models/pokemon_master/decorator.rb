# frozen_string_literal: true

class PokemonMaster
  class Decorator < Azeroth::Decorator
    expose :name
    expose :age
    expose :favorite_pokemon, decorator: Pokemon::FavoriteDecorator
    expose :pokemons

    def name
      [
        first_name,
        last_name
      ].compact.join(' ')
    end
  end
end
