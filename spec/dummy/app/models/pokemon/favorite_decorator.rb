# frozen_string_literal: true

class Pokemon
  class FavoriteDecorator < Pokemon::Decorator
    expose :nickname
  end
end
