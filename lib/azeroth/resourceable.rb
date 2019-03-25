require 'active_support'

module Azeroth
  module Resourceable
    extend ActiveSupport::Concern

    autoload :Builder, 'azeroth/resourceable/builder'

    class_methods do
      def resource_for(name, **options)
        Builder.new(
          self, name, Azeroth::Options.new(options)
        ).build
      end
    end
  end
end
