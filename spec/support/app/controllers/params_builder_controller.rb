# frozen_string_literal: true

class ParamsBuilderController
  def initialize(id, attributes, param_id: :id)
    @params = ActionController::Parameters.new(
      param_id => id,
      document: attributes
    )
  end

  private

  attr_reader :params
end
