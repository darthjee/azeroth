# frozen_string_literal: true

class Movie < ActiveRecord::Base
  validates :name, :director, presence: true
end
