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
      # @param name [String, Symbol] Name of the resource
      # @param options [Hash] resource building options
      # @option options only [Array<Symbol,String>] List of
      #   actions to be built
      # @option options except [Array<Symbol,String>] List of
      #   actions to not to be built
      # @option options decorator [Azeroth::Decorator,TrueClass,FalseClass]
      #   Decorator class or flag allowing/disallowing decorators
      #
      # @return [Array<MethodDefinition>] list of methods created
      #
      # @see Options
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
      def resource_for(name, **options)
        Builder.new(
          self, name, Azeroth::Options.new(options)
        ).build
      end
    end
  end
end
