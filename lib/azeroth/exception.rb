# frozen_string_literal: true

module Azeroth
  class Exception < StandardError
    class NotAllowedAction < Azeroth::Exception; end
  end
end
