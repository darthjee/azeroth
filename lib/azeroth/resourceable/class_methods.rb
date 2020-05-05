# frozen_string_literal: true

module Azeroth
  module Resourceable
    # @api public
    # @author Darthjee
    #
    # Class methods added by {Resourceable}
    module ClassMethods
      # Adds resource methods for resource
      #
      # @param name [String, Symbol] Name of the resource
      # @param options [Hash] resource building options
      # @option options only [Array<Symbol,String>] List of
      #   actions to be built
      # @option options except [Array<Symbol,String>] List of
      #   actions to not to be built
      # @option options decorator [Azeroth::Decorator,TrueClass,FalseClass]
      #   Decorator class or flag allowing/disallowing decorators
      #
      # @return [Array<MethodDefinition>] list of methods created
      #
      # @see Options
      #
      # @example Controller without delete
      #   class DocumentsController < ApplicationController
      #     include Azeroth::Resourceable
      #
      #     resource_for :document, except: :delete
      #   end
      #
      # @example Controller with only create, show and list
      #   class DocumentsController < ApplicationController
      #     include Azeroth::Resourceable
      #
      #     resource_for :document, only: %w[create index show]
      #   end
      def resource_for(name, **options)
        Builder.new(
          self, name, Azeroth::Options.new(options)
        ).build
      end
    end
  end
end
