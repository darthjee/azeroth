# frozen_string_literal: true

class Pokemon
  class Decorator < Azeroth::Decorator
    expose :name
    expose :previous_form_name, as: :evolution_of, if: :evolution?

    def evolution?
      previous_form
    end

    delegate :name, to: :previous_form, prefix: true
  end
end
