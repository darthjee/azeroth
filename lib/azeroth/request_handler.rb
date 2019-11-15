# frozen_string_literal: true

module Azeroth
  class RequestHandler
    autoload :Create,  'azeroth/request_handler/create'
    autoload :Destroy, 'azeroth/request_handler/destroy'
    autoload :Edit,    'azeroth/request_handler/edit'
    autoload :Index,   'azeroth/request_handler/index'
    autoload :New,     'azeroth/request_handler/new'
    autoload :Show,    'azeroth/request_handler/show'
    autoload :Update,  'azeroth/request_handler/update'

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

    def json?
      format == :json
    end

    def format
      params[:format]&.to_sym
    end
  end
end
