class Website < ActiveRecord::Base
  class Decorator < Azeroth::Decorator
    include WithLocation

    expose :location
  end
end
