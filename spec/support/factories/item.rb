# frozen_string_literal: true

FactoryBot.define do
  factory :item, class: '::Item' do
    sequence(:name) { |n| "Item #{n}" }
  end
end
