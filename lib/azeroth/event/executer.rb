# frozen_string_literal: true

module Azeroth
  module Event
    class Executer
      def self.call(before: [], after: [], context:, &block)
        new(before, after, context, &block).call
      end

      def call
        actions(before).each do |action|
          context.instance_eval(&action)
        end

        result = block.call

        actions(after).each do |action|
          context.instance_eval(&action)
        end

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
