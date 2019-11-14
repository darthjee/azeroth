# frozen_string_literal: true

require 'arstotzka'

module Azeroth
  class RequestHandler
    class Index < RequestHandler
      private

      def index
        controller.send(model.plural)
      end
    end
  end
end
