# frozen_string_literal: true

require 'arstotzka'

module Azeroth
  class RequestHandler
    class Index < RequestHandler
      private

      def resource
        controller.send(model.plural)
      end
    end
  end
end
