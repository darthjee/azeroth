require 'active_support'

module Azeroth
  module Resourceable
    extend ActiveSupport::Concern

    autoload :Builder,              'azeroth/resourceable/builder'
    autoload :ResourceBuilder,      'azeroth/resourceable/resource_builder'

    class_methods do
      def resource_for(name, **options)
        Builder.new(self, name, **options).build
      end
    end
  end
end
