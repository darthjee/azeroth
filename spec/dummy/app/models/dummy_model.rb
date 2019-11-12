# frozen_string_literal: true

class DummyModel
  include ActiveModel::Model

  attr_accessor :id, :first_name, :last_name, :age,
                :favorite_pokemon
end
