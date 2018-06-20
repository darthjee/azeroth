module Azeroth
  module Resourceable
    class RoutesBuilder
      attr_reader :model, :builder

      delegate :add_method, to: :builder

      def initialize(model, builder)
        @model = model
        @builder = builder
      end

      def append
        %i[index show new edit create update destroy].each do |route|
          add_method(route, route_code[route].to_s)
        end
      end

      private

      def route_code
        {
          index: :render_basic,
          show: :render_basic,
          new: :render_basic,
          edit: :render_basic,
          create: :render_basic,
          update: :render_basic,
          destroy: <<-RUBY
                   #{model.name}.destroy
                   head :no_content
          RUBY
        }
      end
    end
  end
end
