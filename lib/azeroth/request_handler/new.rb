# frozen_string_literal: true

module Azeroth
  class RequestHandler
    class New < RequestHandler
      private

      def resource
        controller.send(model.plural).new
      end
    end
  end
end
