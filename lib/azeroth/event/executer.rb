# frozen_string_literal: true

module Azeroth
  module Event
    class Executer
      def self.call(before: [], after: [], context:, &block)
        new(before, after, context, &block).call
      end

      def call
        execute_actions(before)
        result = block.call
        execute_actions(after)

        result
      end

      private

      def initialize(before, after, context, &block)
        @before = [before].flatten.compact
        @after = [after].flatten.compact
        @context = context
        @block = block
      end

      attr_reader :before, :after, :context, :block

      def execute_actions(list)
        actions(list).each do |action|
          context.instance_eval(&action)
        end
      end

      def actions(list)
        list.map do |entry|
          if entry.is_a?(Proc)
            proc(&entry)
          else
            proc { send(entry) }
          end
        end
      end
    end
  end
end
