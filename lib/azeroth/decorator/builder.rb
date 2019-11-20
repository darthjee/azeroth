# frozen_string_literal: true

require 'sinclair'

module Azeroth
  class Decorator
    class Builder < Sinclair
      def add(attribute, key, **options)
        add_method(key, "@object.#{attribute}")
      end
    end
  end
end
