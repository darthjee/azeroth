# frozen_string_literal: true

class Website < ActiveRecord::Base
  class Decorator < Azeroth::Decorator
    include WithLocation

    expose :location, override: false

    alias website object
  end
end
