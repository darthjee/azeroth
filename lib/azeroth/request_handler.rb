module Azeroth
  class RequestHandler
    def initialize(controller, model)
      @controller = controller
      @model = model
    end

    private

    attr_reader :controller, :model
  end
end
