# frozen_string_literal: true

FactoryBot.define do
  factory :pokemon_master, class: '::PokemonMaster' do
    sequence(:first_name) { |n| "Ash-#{n}" }
    sequence(:last_name)  { |n| "Ketchum-#{n}" }
    age                   { 10 }
  end
end
