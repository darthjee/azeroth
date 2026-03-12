# frozen_string_literal: true

class Document < ApplicationRecord
  validates :name, presence: true
end
