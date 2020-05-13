# frozen_string_literal: true

module Azeroth
  class RequestHandler
    # @api private
    #
    # hadler for requests to create resources
    class Create < RequestHandler
      private

      # @private
      #
      # Creates and return an instance of the model
      #
      # creation uses the method +"#{model.name}_params"+ to
      # fetch all allowed attributes for creation
      #
      # @return [Object]
      def resource
        @resource ||= build_resource
      end

      # build resource for create
      #
      # @return [Object]
      def build_resource
        @resource = collection.build(attributes)
        controller.instance_variable_set("@#{model.name}", resource)

        trigger_event(:save) do
          resource.tap(&:save)
        end
      end

      # @private
      #
      # Response status
      #
      # For success, returns +:created+, for
      # validation errors, it returns +:unprocessable_entity+
      #
      # @return [Symbol]
      def status
        resource.valid? ? :created : :unprocessable_entity
      end
    end
  end
end
