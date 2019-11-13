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
      fail Azeroth::Exception::NotAllowedAction unless action_allowed?
      return unless json?

      json = resource_json

      controller.instance_eval do
        render(json: json)
      end
    end

    private
    ALLOWED_ACTIONS=%i[index show]

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
      model.decorate(controller.send(model.plural))
    end

    def show
      model.decorate(controller.send(model.name))
    end

    def action_allowed?
      ALLOWED_ACTIONS.include?(action)
    end
  end
end
