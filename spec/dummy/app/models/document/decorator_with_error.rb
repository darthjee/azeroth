# frozen_string_literal: true

class Document
  class DecoratorWithError < Azeroth::Decorator
    expose :name
    expose :errors, if: :invalid?

    def errors
      object.errors.messages
    end
  end
end
