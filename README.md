Azeroth
========
[![Build Status](https://circleci.com/gh/darthjee/azeroth.svg?style=shield)](https://circleci.com/gh/darthjee/azeroth)
[![Code Climate](https://codeclimate.com/github/darthjee/azeroth/badges/gpa.svg)](https://codeclimate.com/github/darthjee/azeroth)
[![Test Coverage](https://codeclimate.com/github/darthjee/azeroth/badges/coverage.svg)](https://codeclimate.com/github/darthjee/azeroth/coverage)
[![Issue Count](https://codeclimate.com/github/darthjee/azeroth/badges/issue_count.svg)](https://codeclimate.com/github/darthjee/azeroth)
[![Gem Version](https://badge.fury.io/rb/azeroth.svg)](https://badge.fury.io/rb/azeroth)
[![Inline docs](http://inch-ci.org/github/darthjee/azeroth.svg)](http://inch-ci.org/github/darthjee/azeroth)

![azeroth](https://raw.githubusercontent.com/darthjee/azeroth/master/azeroth.jpg)

Yard Documentation
-------------------
[https://www.rubydoc.info/gems/azeroth/0.6.3](https://www.rubydoc.info/gems/azeroth/0.6.3)

Azeroth has been designed making the coding of controllers easier
as routes in controllers are usually copy, paste and replace of same
code.

Azeroth was originally developed for controller actions
which will respond with json or template rendering based
on the requested format `.json` or `.html` where `html` rendering
does not perform database operations

Future versions will enable `html` rendering to also perform
database operations.

Usage
-----

## Controller Usage

## Decorator usage
Decoratos are used to define hos an object is exposed as json
on controller responses

```ruby
  # schema.rb

  ActiveRecord::Schema.define do
    self.verbose = false

     create_table :pokemon_masters, force: true do |t|
      t.string :first_name, null: false
      t.string :last_name
      t.integer :age, null: false
    end

    create_table :pokemons, force: true do |t|
      t.string :name, null: false
      t.string :nickname
      t.integer :pokemon_master_id
      t.boolean :favorite
      t.integer :previous_form_id
      t.index %i[pokemon_master_id favorite], unique: true
    end

    add_foreign_key 'pokemons', 'pokemon_masters'
  end
```

```ruby
  # pokemon.rb

  class Pokemon < ActiveRecord::Base
    belongs_to :pokemon_master
    has_one :previous_form,
            class_name: 'Pokemon',
            foreign_key: :previous_form_id

    class Decorator < Azeroth::Decorator
      expose :name
      expose :previous_form_name, as: :evolution_of, if: :evolution?

      def evolution?
        previous_form
      end

      def previous_form_name
        previous_form.name
      end
    end

    class FavoriteDecorator < Pokemon::Decorator
      expose :nickname
    end
  end
```

```ruby
  # pokemon_master.rb

  class PokemonMaster < ActiveRecord::Base
    has_one :favorite_pokemon, -> { where(favorite: true) },
            class_name: 'Pokemon'
    has_many :pokemons

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
```

```ruby
  # test.rb

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

  decorator.as_json
  # returns
  # {
  #   'age' => 10,
  #   'name' => 'Ash Ketchum',
  #   'favorite_pokemon' => {
  #     'name' => 'pikachu',
  #     'nickname' => 'Pikachu'
  #   },
  #   'pokemons' => [{
  #     'name' => 'butterfree',
  #     'evolution_of' => 'metapod'
  #   }, {
  #     'name' => 'squirtle'
  #   }, {
  #     'name' => 'pikachu'
  #   }]
  # }
```
