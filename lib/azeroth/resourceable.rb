require 'active_support'

module Azeroth::Resourceable
  extend ActiveSupport::Concern

  autoload :Builder,              'azeroth/resourceable/builder'
  autoload :RoutesBuilder,        'azeroth/resourceable/routes_builder'
  autoload :ResourceRouteBuilder, 'azeroth/resourceable/resource_route_builder'

  class_methods do
    def resource_for(name, **options)
      Builder.new(self, name, **options).build
    end
  end
end
