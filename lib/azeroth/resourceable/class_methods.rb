# frozen_string_literal: true

module Azeroth
  module Resourceable
    # @api public
    # @author Darthjee
    #
    # Class methods added by {Resourceable}
    module ClassMethods
      # Adds resource methods for resource
      #
      # @param (see Resourceable.resource_for)
      # @option (see Resourceable.resource_for)
      # @return (see Resourceable.resource_for)
      #
      # @see (see Resourceable.resource_for)
      #
      # @example Controller without delete
      #   class DocumentsController < ApplicationController
      #     include Azeroth::Resourceable
      #
      #     resource_for :document, except: :delete
      #   end
      #
      # @example Controller with only create, show and list
      #   class DocumentsController < ApplicationController
      #     include Azeroth::Resourceable
      #
      #     resource_for :document, only: %w[create index show]
      #   end
      #
      # @example complete example gmaes and publishers
      #   class PublishersController < ApplicationController
      #     include Azeroth::Resourceable
      #     skip_before_action :verify_authenticity_token
      #
      #     resource_for :publisher, only: %i[create index]
      #   end
      #
      #   class GamesController < ApplicationController
      #     include Azeroth::Resourceable
      #     skip_before_action :verify_authenticity_token
      #
      #     resource_for :game, except: :delete
      #
      #     private
      #
      #     def games
      #       publisher.games
      #     end
      #
      #     def publisher
      #       @publisher ||= Publisher.find(publisher_id)
      #     end
      #
      #     def publisher_id
      #       params.require(:publisher_id)
      #     end
      #   end
      #
      #   ActiveRecord::Schema.define do
      #     self.verbose = false
      #
      #     create_table :publishers, force: true do |t|
      #       t.string :name
      #     end
      #
      #     create_table :games, force: true do |t|
      #       t.string :name
      #       t.integer :publisher_id
      #     end
      #    end
      #
      #   class Publisher < ActiveRecord::Base
      #     has_many :games
      #   end
      #
      #   class Game < ActiveRecord::Base
      #     belongs_to :publisher
      #   end
      #
      #   class Game::Decorator < Azeroth::Decorator
      #     expose :id
      #     expose :name
      #     expose :publisher, decorator: NameDecorator
      #   end
      #
      # @example requesting games and publishers
      #   post "/publishers.json", params: {
      #     publisher: {
      #       name: 'Nintendo'
      #     }
      #   }
      #
      #   publisher = JSON.parse(response.body)
      #   # returns
      #   # {
      #   #   'id' => 11,
      #   #   'name' => 'Nintendo'
      #   # }
      #
      #   publisher = Publisher.last
      #   post "/publishers/#{publisher['id']}/games.json", params: {
      #     game: {
      #       name: 'Pokemon'
      #     }
      #   }
      #
      #   game = Game.last
      #
      #   JSON.parse(response.body)
      #   # returns
      #   # {
      #   #   id: game.id,
      #   #   name: 'Pokemon',
      #   #   publisher: {
      #   #     name: 'Nintendo'
      #   # }
      #   }
      #
      # @example Controller with before_save
      #   class PokemonsController < ApplicationController
      #     include Azeroth::Resourceable
      #
      #     resource_for :pokemon,
      #                  only: %i[create update],
      #                  before_save: :set_favorite
      #
      #     private
      #
      #     def set_favorite
      #       pokemon.favorite = true
      #     end
      #
      #     def pokemons
      #       master.pokemons
      #     end
      #
      #     def master
      #       @master ||= PokemonMaster.find(master_id)
      #     end
      #
      #     def master_id
      #       params.require(:pokemon_master_id)
      #     end
      #   end
      def resource_for(name, **options)
        Builder.new(
          self, name, Azeroth::Options.new(options)
        ).build
      end
    end
  end
end
