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

## Azeroth::Resourceable
[Resourceable](https://www.rubydoc.info/gems/azeroth/Azeroth/Resourceable)
module adds class method [resource_for](https://www.rubydoc.info/gems/azeroth/Azeroth/Resourceable/ClassMethods#resource_for-instance_method)
which adds a resource and action methods for `create`, `show`, `index`,
`update`, `delete`, `edit`

It accepts options
- only List of actions to be built
- except List of actions to not to be built
- decorator Decorator class or flag allowing/disallowing decorators

```ruby
  # publishers_controller.rb

  class PublishersController < ApplicationController
    include Azeroth::Resourceable
    skip_before_action :verify_authenticity_token

    resource_for :publisher, only: %i[create index]
  end
```

```ruby
  # games_controller.rb

  class GamesController < ApplicationController
    include Azeroth::Resourceable
    skip_before_action :verify_authenticity_token

    resource_for :game, except: :delete

    private

    def games
      publisher.games
    end

    def publisher
      @publisher ||= Publisher.find(publisher_id)
    end

    def publisher_id
      params.require(:publisher_id)
    end
  end
```

```ruby
  # schema.rb

  ActiveRecord::Schema.define do
    self.verbose = false

    create_table :publishers, force: true do |t|
      t.string :name
    end

    create_table :games, force: true do |t|
      t.string :name
      t.integer :publisher_id
    end
   end
```

```ruby
  # publisher.rb

  class Publisher < ActiveRecord::Base
    has_many :games
  end
```

```ruby
  # game.rb

  class Game < ActiveRecord::Base
    belongs_to :publisher
  end
```

```ruby
  # game/decorator.rb

  class Game::Decorator < Azeroth::Decorator
    expose :id
    expose :name
    expose :publisher, decorator: NameDecorator
  end
```

```ruby
  post "/publishers.json", params: {
    publisher: {
      name: 'Nintendo'
    }
  }

  publisher = JSON.parse(response.body)
  # returns
  # {
  #   'id' => 11,
  #   'name' => 'Nintendo'
  # }

  publisher = Publisher.last
  post "/publishers/#{publisher['id']}/games.json", params: {
    game: {
      name: 'Pokemon'
    }
  }

  game = Game.last

  JSON.parse(response.body)
  # returns
  # {
  #   id: game.id,
  #   name: 'Pokemon',
  #   publisher: {
  #     name: 'Nintendo'
  # }
  }
```

## Azeroth::Decorator
[Decorators](https://www.rubydoc.info/gems/azeroth/Azeroth/Decorator) are
used to define how an object is exposed as json on controller responses
defining which and how fields will be exposed

```ruby
  # pokemon/decorator.rb

  class Pokemon::Decorator < Azeroth::Decorator
    expose :name
    expose :previous_form_name, as: :evolution_of, if: :evolution?

    def evolution?
      previous_form
    end

    def previous_form_name
      previous_form.name
    end
  end
```

```ruby
  # pokemon/favorite_decorator.rb

  class Pokemon::FavoriteDecorator < Pokemon::Decorator
    expose :nickname
  end
```

```ruby
  # pokemon_master/decorator.rb

  class PokemonMaster < ActiveRecord::Base
    has_one :favorite_pokemon, -> { where(favorite: true) },
            class_name: 'Pokemon'
    has_many :pokemons
  end
```

```ruby
  # pokemon.rb

  class Pokemon < ActiveRecord::Base
    belongs_to :pokemon_master
    has_one :previous_form,
            class_name: 'Pokemon',
            foreign_key: :previous_form_id
  end
```

```ruby
  # pokemon_master.rb

  class PokemonMaster::Decorator < Azeroth::Decorator
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
```

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

Exposing is done through the class method
[expose](https://www.rubydoc.info/gems/azeroth/Azeroth/Decorator#expose-class_method)
which accepts several options:

- as: custom key to expose
- if: method/block to be called checking if an attribute should or should not be exposed
- decorator: flag to use or not a decorator or decorator class to be used
