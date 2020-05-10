# frozen_string_literal: true

require 'spec_helper'

RSpec.describe PokemonMastersController do
  describe 'POST create' do
    let(:parameters) do
      {
        format: :json,
        pokemon_master: {
          first_name: 'Ash'
        }
      }
    end

    it 'creates pokemon master' do
      expect { post :create, params: parameters }
        .to change(PokemonMaster, :count)
        .by(1)
    end

    it 'updates pokemon master age' do
      post :create, params: parameters

      expect(PokemonMaster.last.age).to eq(10)
    end
  end

  describe 'POST update' do
    let(:master) do
      create(:pokemon_master, age: 20, last_name: nil)
    end

    let(:parameters) do
      {
        id: master.id,
        format: :json,
        pokemon_master: { last_name: 'Joe' }
      }
    end

    it 'updates pokemon master' do
      expect { post :update, params: parameters }
        .to change { master.reload.last_name }
        .from(nil)
        .to('Joe')
    end

    it 'updates pokemon master age' do
      expect { post :update, params: parameters }
        .to change { master.reload.age }
        .from(20)
        .to(10)
    end
  end
end
