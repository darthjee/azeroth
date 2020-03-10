# frozen_string_literal: true

FactoryBot.define do
  factory :document, class: '::Document' do
    sequence(:name) { |n| "Name-#{n}" }
  end
end
