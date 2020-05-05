# frozen_string_literal: true

require 'spec_helper'

describe GamesController, controller: true do
  describe 'POST create' do
    it 'create game' do
      post '/publishers.json', params: {
        publisher: {
          name: 'Nintendo'
        }
      }

      publisher = JSON.parse(response.body)
      expect(publisher)
        .to eq({
                 'id' => publisher['id'],
                 'name' => 'Nintendo'
               })

      publisher = Publisher.last
      post "/publishers/#{publisher['id']}/games.json", params: {
        game: {
          name: 'Pokemon'
        }
      }

      game = Game.last

      expect(JSON.parse(response.body))
        .to eq({
                 id: game.id,
                 name: 'Pokemon',
                 publisher: {
                   name: 'Nintendo'
                 }
               })
    end
  end
end
