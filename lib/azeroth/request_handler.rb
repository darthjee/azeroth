module Azeroth
  class RequestHandler
    def initialize(controller, model)
      @controller = controller
      @model = model
    end

    def process
      model.klass.all.to_json
    end

    private

    attr_reader :controller, :model
  end
end
