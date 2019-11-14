# frozen_string_literal: true

require 'arstotzka'

module Azeroth
  class RequestHandler
    include Arstotzka

    autoload :Index,  'azeroth/request_handler/index'
    autoload :Show,   'azeroth/request_handler/show'
    autoload :Update, 'azeroth/request_handler/update'

    def initialize(controller, model)
      @controller = controller
      @model = model
    end

    def process
      raise Azeroth::Exception::NotAllowedAction unless action_allowed?
      return unless json?

      resource = send(action)
      json = model.decorate(resource)

      controller.instance_eval do
        render(json: json)
      end
    end

    private

    ALLOWED_ACTIONS = %i[index show update].freeze

    attr_reader :controller, :model

    delegate :params, to: :controller

    expose :format, :action, type: :symbol, json: :params

    def json?
      format == :json
    end

    def index
      controller.send(model.plural)
    end

    def show
      controller.send(model.name)
    end

    def update
      attributes = controller.send("#{model.name}_params")
      resource = controller.send(model.name)
      resource.update(attributes)
      resource
    end

    def action_allowed?
      ALLOWED_ACTIONS.include?(action)
    end
  end
end
