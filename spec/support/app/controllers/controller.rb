# frozen_string_literal: true

require 'action_controller'

class Controller < ActionController::Base
  def initialize(params = {})
    super
    @params = ActionController::Parameters.new(params)
  end

  private

  attr_reader :params
end
