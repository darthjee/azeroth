# frozen_string_literal: true

FactoryBot.define do
  factory :game, class: '::Game' do
    sequence(:name) { |n| "Game #{n}" }
    publisher
  end
end
