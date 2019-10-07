# frozen_string_literal: true

class RoutesBuilderController
  def initialize(id: nil, document: nil)
    @id = id
    @document_params = document
  end

  def perform(action)
    @action = action
    send(action)
  end

  private

  attr_reader :id, :document_params, :action

  def render_basic
    {
      json: "#{action}_json"
    }
  end
end
