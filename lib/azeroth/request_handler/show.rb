# frozen_string_literal: true

require 'arstotzka'

module Azeroth
  class RequestHandler
    class Show < RequestHandler
      private

      def resource
        controller.send(model.name)
      end
    end
  end
end
