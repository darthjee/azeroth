# frozen_string_literal: true

module Azeroth
  class RequestHandler
    # @api private
    #
    # hadler for requests to edit resources
    #
    # This handler does the same as {Show}
    # returning the model for editing
    class Edit < RequestHandler::Show
    end
  end
end
