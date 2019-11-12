# frozen_string_literal: true

class DummyModel
  class Decorator < Azeroth::Decorator
    expose :name
    expose :age
    expose :favorite_pokemon, as: :pokemon

    def name
      [object.first_name, object.last_name].join(' ')
    end
  end
end
