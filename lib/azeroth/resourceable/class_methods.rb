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
      # @param (see Resourceable.resource_for)
      # @option (see Resourceable.resource_for)
      # @return (see Resourceable.resource_for)
      #
      # @see (see Resourceable.resource_for)
      # @example (see Resourceable.resource_for)
      def resource_for(name, **options)
        Builder.new(
          self, name, Azeroth::Options.new(options)
        ).build
      end
    end
  end
end
