# frozen_string_literal: true

require 'arstotzka'

module Azeroth
  class RequestHandler
    class Destroy < RequestHandler
      private

      def resource
        resource = controller.send(model.name)
        resource.tap(&:destroy)
      end
    end
  end
end
