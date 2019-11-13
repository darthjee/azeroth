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
      json = case action
             when :index
               index
             when :show
               show
      end

      controller.instance_eval do
        render(json: json)
      end
    end

    private

    attr_reader :controller, :model

    delegate :params, to: :controller

    expose :format, :action, type: :symbol, json: :params
    expose :id, json: :params

    def index
      model.klass.all.to_json
    end

    def show
      model.klass.all.find(id).to_json
    end
  end
end
