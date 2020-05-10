# frozen_string_literal: true

class PokemonsController < ApplicationController
  include Azeroth::Resourceable

  resource_for :pokemon,
    only: [:create, :update],
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
