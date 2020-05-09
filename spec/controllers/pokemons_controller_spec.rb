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
  end
end
