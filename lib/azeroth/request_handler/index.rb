# frozen_string_literal: true

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
