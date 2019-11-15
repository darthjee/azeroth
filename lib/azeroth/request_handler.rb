# frozen_string_literal: true

module Azeroth
  # @api private
  #
  # Handle a request on behalf of the controller
  #
  # Request handler sends messages to the controller
  # in order to get the resource and rendering the response
  class RequestHandler
    autoload :Create,  'azeroth/request_handler/create'
    autoload :Destroy, 'azeroth/request_handler/destroy'
    autoload :Edit,    'azeroth/request_handler/edit'
    autoload :Index,   'azeroth/request_handler/index'
    autoload :New,     'azeroth/request_handler/new'
    autoload :Show,    'azeroth/request_handler/show'
    autoload :Update,  'azeroth/request_handler/update'

    # @param controller [ApplicationController]
    # @param model [Azeroth::Model]
    def initialize(controller, model)
      @controller = controller
      @model = model
    end

    # process the request
    #
    # No action is performd when format is HTML
    #
    # When format is json, the resource is fetched/processed
    # (by the subclass) and returned as json (decorated)
    #
    # @return [String]
    def process
      return unless json?

      json = model.decorate(resource)

      controller.instance_eval do
        render(json: json)
      end
    end

    private

    attr_reader :controller, :model
    # @method controller
    # @api private
    # @private
    #
    # Controller to receive the message
    #
    # @return [ApplicationController]

    # @method model
    # @api private
    # @private
    #
    # Model interface
    #
    # @return [Azeroth::Model]

    delegate :params, to: :controller
    # @method params
    # @api private
    # @private
    #
    # request parameters
    #
    # @return [ActionController::Parameters]

    # Checks if request format is json
    def json?
      params[:format]&.to_s == 'json'
    end
  end
end
