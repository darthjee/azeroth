# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PokemonsController do
  let(:master) { create(:pokemon_master) }

  describe 'POST create' do
    let(:parameters) do
      {
        pokemon_master_id: master.id,
        format: :json,
        pokemon: { name: 'Bulbasaur' }
      }
    end

    it 'creates pokemon' do
      expect { post :create, params: parameters }
        .to change(Pokemon, :count)
        .by(1)
    end

    it 'updates pokemon to be favorite' do
      expect { post :create, params: parameters }
        .to change { master.reload.favorite_pokemon }
        .from(nil)
    end
  end

  describe 'POST update' do
    let(:pokemon) { create(:pokemon) }
    let(:master)  { pokemon.pokemon_master }

    let(:parameters) do
      {
        pokemon_master_id: master.id,
        id: pokemon.id,
        format: :json,
        pokemon: { name: 'Butterfree' }
      }
    end

    it 'updates pokemon' do
      expect { post :update, params: parameters }
        .to change { pokemon.reload.name }
        .from('Bulbasaur')
        .to('Butterfree')
    end

    it 'updates pokemon to be favorite' do
      expect { post :update, params: parameters }
        .to change { pokemon.reload.favorite }
        .from(nil)
    end
  end
end
