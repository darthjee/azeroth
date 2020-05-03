# frozen_string_literal: true

class Product
  class DecoratorWithFactory < Azeroth::Decorator
    expose :name
    expose :factory
  end
end
