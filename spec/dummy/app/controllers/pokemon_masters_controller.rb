# frozen_string_literal: true

class PokemonMastersController < ApplicationController
  include Azeroth::Resourceable

  resource_for :pokemon_master,
    only: [:create, :update],
    before_save: proc { pokemon_master.age = 10 }
end
