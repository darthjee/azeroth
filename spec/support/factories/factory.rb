# frozen_string_literal: true

FactoryBot.define do
  factory :factory, class: '::Factory' do
    sequence(:name) { |n| "Factory ###{n}" }
  end
end
