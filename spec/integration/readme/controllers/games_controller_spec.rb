# frozen_string_literal: true

require 'spec_helper'

describe GamesController, controller: true do
  describe 'POST create' do
    let(:publisher) { create(:publisher, name: 'Nintendo') }

    it 'create game' do
      post "/publishers/#{publisher.id}/games.json", params: {
        game: {
          name: 'Pokemon'
        }
      }

      game = Game.last

      expect(response.body).to eq({
        id: game.id,
        name: 'Pokemon',
        publisher: {
          id: publisher.id,
          name: 'Nintendo'
        }
      }.to_json)
    end
  end
end
