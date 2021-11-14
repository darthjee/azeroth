# frozen_string_literal: true

class RenderingController < ApplicationController
  include Azeroth::Resourceable

  helper_method :document

  resource_for :document
end

