# frozen_string_literal: true

FactoryBot.define do
  factory :product, class: '::Product' do
    sequence(:name) { |n| "Product ###{n}" }
    association :factory
  end
end
