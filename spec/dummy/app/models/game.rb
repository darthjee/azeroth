# frozen_string_literal: true

class Game < ActiveRecord::Base
  belongs_to :publisher
end
