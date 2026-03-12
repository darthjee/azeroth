# frozen_string_literal: true

class Movie < ApplicationRecord
  validates :name, :director, presence: true
end
