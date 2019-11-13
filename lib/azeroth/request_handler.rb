# frozen_string_literal: true

module Azeroth
  class RequestHandler
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

    def index
      model.klass.all.to_json
    end

    def show
      model.klass.all.find(id).to_json
    end

    def format
      params[:format].to_sym
    end

    def action
      params[:action].to_sym
    end

    def id
      params[:id]
    end
  end
end
