# frozen_string_literal: true

module RSpec
  module CustomMatchers
    class AddMethod < Matchers::BuiltIn::BaseMatcher
      attr_reader :method

      def initialize(method = nil)
        super
        @method = method
      end

      def to(instance = nil, &)
        AddMethodTo.new(instance, method, &)
      end
    end

    class AddMethodTo < Matchers::BuiltIn::BaseMatcher
      attr_reader :method, :instance, :block

      def initialize(instance, method, &block)
        super
        @instance = instance
        @method = method
        @block = block
      end

      def description
        "Adds method #{method} to #{instance_class}"
      end

      def failure_message
        "expected #{method} to be added to #{instance_class} but " \
          "#{@initial_state ? 'it already existed' : "it didn't"}"
      end

      def matches?(event_proc)
        @event_proc = event_proc
        return false unless event_proc.is_a?(Proc)

        raise_block_syntax_error if block_given?
        perform_change(event_proc)
        changed?
      end

      def supports_block_expectations?
        true
      end

      private

      def changed?
        !@initial_state && @final_state
      end

      def perform_change(event_proc)
        @initial_state = evaluated_instance.respond_to?(method)
        @evaluated_instance = nil
        event_proc.call
        @final_state = evaluated_instance.respond_to?(method)
      end

      def evaluated_instance
        @evaluated_instance ||= instance || block.call
      end

      def instance_class
        @instance_class ||= evaluated_instance.class
      end

      def raise_block_syntax_error
        raise SyntaxError, 'Block not received by the' \
                           '`add_method_to` matcher. ' \
                           'Perhaps you want to use `{ ... }` instead of do/end?'
      end
    end
  end
end

module RSpec
  module Matchers
    def add_method(_method)
      CustomMatchers::AddMethod.new(:index)
    end
  end
end
