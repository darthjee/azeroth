# frozen_string_literal: true

require 'arstotzka'

module Azeroth
  class RequestHandler
    include Arstotzka

    autoload :Index,  'azeroth/request_handler/index'
    autoload :New,    'azeroth/request_handler/new'
    autoload :Show,   'azeroth/request_handler/show'
    autoload :Update, 'azeroth/request_handler/update'

    def initialize(controller, model)
      @controller = controller
      @model = model
    end

    def process
      return unless json?

      json = model.decorate(resource)

      controller.instance_eval do
        render(json: json)
      end
    end

    private

    attr_reader :controller, :model

    delegate :params, to: :controller

    expose :format, type: :symbol, json: :params

    def json?
      format == :json
    end
  end
end
