# frozen_string_literal: true

class Document < ActiveRecord::Base
  validates :name, presence: true
end
