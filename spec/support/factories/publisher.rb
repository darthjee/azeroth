# frozen_string_literal: true

FactoryBot.define do
  factory :publisher, class: '::Publisher' do
    sequence(:name) { |n| "Publisher #{n}" }
  end
end
