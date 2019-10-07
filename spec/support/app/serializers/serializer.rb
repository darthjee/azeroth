# frozen_string_literal: true

module Serializer
  def self.serialize(object)
    case object
    when Hash
      object
    else
      object.as_json
    end
  end
end
