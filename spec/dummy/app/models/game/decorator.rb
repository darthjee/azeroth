# frozen_string_literal: true

class Game < ActiveRecord::Base
  class Decorator < Azeroth::Decorator
    expose :id
    expose :name
    expose :publisher, decorator: NameDecorator
  end
end
