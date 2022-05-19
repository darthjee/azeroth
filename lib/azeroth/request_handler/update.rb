# frozen_string_literal: true

module Azeroth
  class RequestHandler
    # @api private
    #
    # hadler for requests to update resource
    class Update < RequestHandler
      private

      delegate :update_with, to: :options

      # @private
      #
      # Updates and return an instance of the model
      #
      # update uses the method +"#{model.name}_params"+ to
      # fetch all allowed attributes for update
      #
      # @return [Object]
      def resource
        @resource ||= perform_update
      end

      # Update a resource saving it to the database
      #
      # @return [Object]
      def perform_update
        @resource = controller.send(model.name)
        resource.tap do
          trigger_event(:save) do
            update_and_save_resource
          end
        end
      end

      def update_and_save_resource
        return resource.update(attributes) unless update_with

        case update_with
        when Proc
          controller.instance_eval(&update_with)
        else
          controller.send(build_with)
        end
      end

      # @private
      #
      # Response status
      #
      # For success, returns +:ok+, for
      # validation errors, it returns +:unprocessable_entity+
      #
      # @return [Symbol]
      def status
        resource.valid? ? :ok : :unprocessable_entity
      end
    end
  end
end
