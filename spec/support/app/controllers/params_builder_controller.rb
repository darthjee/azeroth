# frozen_string_literal: true

class ParamsBuilderController
  def initialize(id, attributes)
    @params = ActionController::Parameters.new(
      id: id,
      document: attributes
    )
  end

  private

  attr_reader :params
end
