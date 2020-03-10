# frozen_string_literal: true

FactoryBot.define do
  factory :dummy_model, class: '::DummyModel' do
    sequence(:id)
    first_name       { 'dummy' }
    last_name        { 'bot' }
    age              { 21 }
    favorite_pokemon { 'squirtle' }
  end
end
