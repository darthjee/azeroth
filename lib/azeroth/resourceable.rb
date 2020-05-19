# frozen_string_literal: true

require 'active_support'

module Azeroth
  # @api public
  # @author Darthjee
  #
  # Concern for building controller methods for the routes
  #
  # @example (see Resourceable::ClassMethods#resource_for)
  #
  # @see Resourceable::ClassMethods
  module Resourceable
    extend ActiveSupport::Concern

    included do
      rescue_from ActiveRecord::RecordNotFound, with: :not_found
    end

    autoload :Builder, 'azeroth/resourceable/builder'
    autoload :ClassMethods, 'azeroth/resourceable/class_methods'

    class << self
      # @method self.resource_for(name, **options)
      # @api public
      #
      # @param name [String, Symbol] Name of the resource
      # @param options [Hash] resource building options
      # @option options only [Array<Symbol,String>] List of
      #   actions to be built
      # @option options except [Array<Symbol,String>] List of
      #   actions to not to be built
      # @option options decorator [Azeroth::Decorator,TrueClass,FalseClass]
      #   Decorator class or flag allowing/disallowing decorators
      # @option options before_save [Symbol,Proc] method/block
      #   to be ran on the controller before saving the resource
      # @option options build_with [Symbol,Proc] method/block
      #   to be ran when building resource
      #   (default proc { <resource_collection>.build(resource_params) }
      #
      # @return [Array<MethodDefinition>] list of methods created
      #
      # @see Options::DEFAULT_OPTIONS
    end

    private

    # @api private
    # @private
    #
    # returns 404 as HTTP status
    #
    # @return [TrueClass]
    def not_found
      head :not_found
    end
  end
end
