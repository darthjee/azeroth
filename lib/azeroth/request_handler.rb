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
      raise Azeroth::Exception::NotAllowedAction unless action_allowed?
      return unless json?

      json = send(action)

      controller.instance_eval do
        render(json: json)
      end
    end

    private

    ALLOWED_ACTIONS = %i[index show].freeze

    attr_reader :controller, :model

    delegate :params, to: :controller

    expose :format, :action, type: :symbol, json: :params
    expose :id, json: :params

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
