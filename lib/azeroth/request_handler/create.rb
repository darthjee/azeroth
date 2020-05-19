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
        if options.build_with
          if options.build_with.is_a?(Proc)
            @resource = controller.instance_eval(&options.build_with)
          else
            @resource = controller.send(options.build_with)
          end
        else
          @resource = collection.build(attributes)
        end
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
