# frozen_string_literal: true

class Pokemon
  class Decorator < Azeroth::Decorator
    expose :name
    expose :previous_form_name, as: :evolution_of, if: :evolution?

    def evolution?
      previous_form
    end

    def previous_form_name
      previous_form.name
    end
  end
end
