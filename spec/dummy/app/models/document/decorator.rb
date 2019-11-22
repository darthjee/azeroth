# frozen_string_literal: true

class Document
  class Decorator < Azeroth::Decorator
    expose :name
    expose :reference, if: proc(&:magic?)

    def magic?
      reference&.match(/^X-MAGIC/)
    end
  end
end
