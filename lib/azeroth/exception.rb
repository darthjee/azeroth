module Azeroth
  class Exception < ::StandardError
    class InvalidOptions < Azeroth::Exception; end
  end
end
