require 'action_controller'

class Controller
  def initialize(params = {})
    @params = ActionController::Parameters.new(params)
  end

  private

  attr_reader :params
end
