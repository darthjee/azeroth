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
    def initialize(controller, model, options)
      @controller = controller
      @model = model
      @options = options
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

      json            = model.decorate(resource)
      response_status = status

      controller.instance_eval do
        render(json: json, status: response_status)
      end
    end

    private

    attr_reader :controller, :model, :options
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

    # @method optsion
    # @api private
    # @private
    #
    # Handling options
    #
    # @return [Azeroth::Options]

    delegate :params, to: :controller
    # @method params
    # @api private
    # @private
    #
    # request parameters
    #
    # @return [ActionController::Parameters]

    # @private
    #
    # Checks if request format is json
    #
    # @return [TrueClass,FalseClass]
    def json?
      params[:format]&.to_s == 'json'
    end

    # @private
    #
    # Resource to be serialized and returned
    #
    # Must be implemented in subclass
    #
    # @return [Object]
    # @raise Not implmented
    def resource
      raise 'must be implemented in subclass'
    end

    # @private
    #
    # Response status
    #
    # For most requests, status is 200 (+:ok+)
    #
    # Must be implemented in subclasses that will handle
    # status differently
    #
    # @return [Symbol]
    def status
      :ok
    end

    def trigger_event(event, &block)
      options.event_dispatcher(event)
        .dispatch(controller, &block)
    end
  end
end
