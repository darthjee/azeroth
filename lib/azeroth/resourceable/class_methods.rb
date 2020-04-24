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
      # @param (see Options#initialize)
      # @option (see Options#initialize)
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
