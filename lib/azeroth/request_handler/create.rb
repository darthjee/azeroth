# frozen_string_literal: true

module Azeroth
  class RequestHandler
    # @api private
    #
    # hadler for requests to create resources
    class Create < RequestHandler
      private

      delegate :build_with, to: :options

      # @private
      #
      # Creates and return an instance of the model
      #
      # creation uses the method +"#{model.name}_params"+ to
      # fetch all allowed attributes for creation
      #
      # @return [Object]
      def resource
        @resource ||= build_and_save_resource
      end

      # @private
      #
      # build resource for create and save it
      #
      # @return [Object]
      def build_and_save_resource
        @resource = build_resource
        controller.instance_variable_set("@#{model.name}", resource)

        trigger_event(:save) do
          resource.tap(&:save)
        end
      end

      # @private
      #
      # build resource without saving it
      #
      # when +build_with+ option is given, the proc/method
      # is called instead of collection.build
      #
      # @return [Object] resource built
      def build_resource
        return collection.build(attributes) unless build_with

        case build_with
        when Proc
          controller.instance_eval(&build_with)
        else
          controller.send(build_with)
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
