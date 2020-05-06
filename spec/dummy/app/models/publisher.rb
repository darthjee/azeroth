# frozen_string_literal: true

class Publisher < ActiveRecord::Base
  has_many :games
end
