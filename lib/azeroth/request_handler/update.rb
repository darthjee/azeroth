# frozen_string_literal: true

module Azeroth
  class RequestHandler
    # @api private
    #
    # hadler for requests to update resource
    class Update < RequestHandler
      private

      # @private
      #
      # Updates and return an instance of the model
      #
      # update uses the method +"#{model.name}_params"+ to
      # fetch all allowed attributes for update
      #
      # @return [Object]
      def resource
        @resource ||= update_resource
      end

      # build resource for update
      #
      # @return [Object]
      def update_resource
        attributes = controller.send("#{model.name}_params")

        controller.send(model.name).tap do |entry|
          if options.before_save
            before_save = options.before_save
            if options.before_save.is_a? Proc
              block = proc(&before_save)
            else
              block = proc { send(before_save) }
            end

            controller.instance_eval(&block)
          end

          entry.update(attributes)
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
