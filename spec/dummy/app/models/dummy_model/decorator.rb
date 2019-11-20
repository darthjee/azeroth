# frozen_string_literal: true

class DummyModel
  class Decorator < Azeroth::Decorator
    expose :name
    expose :age
    expose :favorite_pokemon, as: :pokemon
    expose :errors, if: :invalid?

    def name
      [object.first_name, object.last_name].compact.join(' ')
    end

    def errors
      object.valid?
      object.errors.messages
    end
  end
end
