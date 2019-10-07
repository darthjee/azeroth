# frozen_string_literal: true

module Azeroth
  class RoutesBuilder
    attr_reader :model, :builder

    delegate :add_method, to: :builder

    def initialize(model, builder, options)
      @model = model
      @builder = builder
      @options = options
    end

    def append
      %i[index show new edit create update].each do |route|
        add_method(route, 'render_basic')
      end

      add_method(:destroy, destroy)
    end

    private

    def destroy
      <<-RUBY
        #{model.name}.destroy
        head :no_content
      RUBY
    end
  end
end
