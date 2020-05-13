# frozen_string_literal: true

FactoryBot.define do
  factory :pokemon, class: '::Pokemon' do
    name { 'Bulbasaur' }
    pokemon_master
  end
end
