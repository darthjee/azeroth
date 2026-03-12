# frozen_string_literal: true

class DummyModel
  include ActiveModel::Model

  attr_accessor :id, :first_name, :last_name, :age,
                :favorite_pokemon, :favorite_game

  validates :first_name, presence: true

  private

  def private_name
    "Secret #{last_name}"
  end
end
