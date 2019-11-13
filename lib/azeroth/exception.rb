# frozen_string_literal: true

module Azeroth
  class Exception < StandardError
    class NotAllowedAction < RuntimeError; end
  end
end
