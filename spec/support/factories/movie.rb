# frozen_string_literal: true

FactoryBot.define do
  factory :movie, class: '::Movie' do
    sequence(:name)     { |n| "Name-#{n}" }
    sequence(:director) { |n| "Director-#{n}" }
  end
end
