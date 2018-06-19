module Azeroth::Resourceable
  class RoutesBuilder
    attr_reader :resource, :builder

    delegate :add_method, to: :builder

    def initialize(resource, builder)
      @resource = resource
      @builder = builder
    end

    def append
      %i(index show new edit create update).each do |route|
        add_method(route, 'render_basic')
      end
      add_method(:destroy, %{
        #{resource}.destroy
        head :no_content
      })
    end
  end
end
