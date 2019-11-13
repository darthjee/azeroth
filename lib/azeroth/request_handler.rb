# frozen_string_literal: true

require 'arstotzka'

module Azeroth
  class RequestHandler
    include Arstotzka

    def initialize(controller, model)
      @controller = controller
      @model = model
    end

    def process
      return unless json?

      json = resource_json

      controller.instance_eval do
        render(json: json)
      end
    end

    private

    attr_reader :controller, :model

    delegate :params, to: :controller

    expose :format, :action, type: :symbol, json: :params
    expose :id, json: :params

    def resource_json
      case action
      when :index
        index
      when :show
        show
      end
    end

    def json?
      format == :json
    end

    def index
      controller.send(model.plural).to_json
    end

    def show
      controller.send(model.name).to_json
    end
  end
end
