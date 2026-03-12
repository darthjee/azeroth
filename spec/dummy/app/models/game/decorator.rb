# frozen_string_literal: true

class Game < ApplicationRecord
  class Decorator < Azeroth::Decorator
    expose :id
    expose :name
    expose :publisher, decorator: NameDecorator
  end
end
