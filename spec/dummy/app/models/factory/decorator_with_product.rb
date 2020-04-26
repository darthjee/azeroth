# frozen_string_literal: true

class Factory
  class DecoratorWithProduct < Azeroth::Decorator
    expose :name
    expose :main_product
  end
end
