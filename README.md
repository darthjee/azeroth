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
[https://www.rubydoc.info/gems/azeroth/2.1.1](https://www.rubydoc.info/gems/azeroth/2.1.1)

Azeroth has been designed making the coding of controllers easier
as routes in controllers are usually copy, paste and replace of same
code.

Azeroth was originally developed for controller actions
which will respond with json or template rendering based
on the requested format `.json` or `.html` where `html` rendering
does not perform database operations

Future versions will enable `html` rendering to also perform
database operations.

Current Release: [2.1.1](https://github.com/darthjee/azeroth/tree/2.1.1)

[Next release](https://github.com/darthjee/azeroth/compare/2.1.1...master)

Installation
---------------

- Install it

```ruby
  gem install azeroth
```

- Or add Sinclair to your `Gemfile` and `bundle install`:

```ruby
  gem 'azeroth'
```

```bash
  bundle install azeroth
```

Usage
-----

## Azeroth::Resourceable

[Resourceable](https://www.rubydoc.info/gems/azeroth/Azeroth/Resourceable)
module adds class methods
[resource_for](https://www.rubydoc.info/gems/azeroth/Azeroth/Resourceable/ClassMethods#resource_for-instance_method)
which adds a resource and action methods for `create`, `show`, `index`,
`update`, `delete`, `edit`
and
[model_for](https://www.rubydoc.info/gems/azeroth/Azeroth/Resourceable/ClassMethods#model_for-instance_method)

### #resource_for
It accepts options
- only: List of actions to be built
- except: List of actions to not to be built
- decorator: Decorator class or flag allowing/disallowing decorators
- before_save: Method/Proc to be ran before saving the resource on create or update
- after_save: Method/Proc to be ran after saving the resource on create or update
- build_with: Method/Block to be ran when building the reource on create
- update_with: Method/Block to be ran when updating the reource on update
- paginated: Flag when pagination should be applied
- per_page: Number of items returned when pagination is active
- id_key: key used to find a model. id by default
- param_key: parameter key used to find the model

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
  # pokemons_controller.rb

  class PokemonsController < ApplicationController
    include Azeroth::Resourceable

    resource_for :pokemon,
                 only: %i[create update],
                 before_save: :set_favorite

    private

    def set_favorite
      pokemon.favorite = true
    end

    def pokemons
      master.pokemons
    end

    def master
      @master ||= PokemonMaster.find(master_id)
    end

    def master_id
      params.require(:pokemon_master_id)
    end
  end
```

```ruby
  class PaginatedDocumentsController < ApplicationController
    include Azeroth::Resourceable

    resource_for :document, only: 'index', paginated: true
  end

  30.times { create(:document) }

  get '/paginated_documents.json'

  # returns Array with 20 first documents
  # returns in the headers pagination headers
  # {
  #   'pages' => 2,
  #   'per_page' => 20,
  #   'page' => 1
  # }

  get '/paginated_documents.json?page=2'

  # returns Array with 10 next documents
  # returns in the headers pagination headers
  # {
  #   'pages' => 2,
  #   'per_page' => 20,
  #   'page' => 2
  # }
```

### #model_for
It accepts options
- id_key: key used to find a model. id by default
- param_key: parameter key used to find the model

## Azeroth::Decorator

[Decorators](https://www.rubydoc.info/gems/azeroth/Azeroth/Decorator) are
used to define how an object is exposed as json on controller responses
defining which and how fields will be exposed

Exposing options:

- as: custom key to expose the value as
- if: method/block to be called checking if an attribute should or should not be exposed
- decorator: flag to use or not a decorator or decorator class to be used
- reader: Flag indicating if a reader to access the attribute should be created. usefull if you want method_missing to take over
- override: Flag indicating if an existing method should be overriden. This is useful when a method acessor was included from another module

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

Exposing is done through the class method
[expose](https://www.rubydoc.info/gems/azeroth/Azeroth/Decorator#expose-class_method)
which accepts several options:

- as: custom key to expose
- if: method/block to be called checking if an attribute should or should not be exposed
- decorator: flag to use or not a decorator or decorator class to be used
