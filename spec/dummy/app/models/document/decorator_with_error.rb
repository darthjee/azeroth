# frozen_string_literal: true

class Document
  class DecoratorWithError < Document::Decorator
    expose :errors, if: :invalid?

    def errors
      object.errors.messages
    end
  end
end
