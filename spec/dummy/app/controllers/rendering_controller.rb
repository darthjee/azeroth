# frozen_string_literal: true

class RenderingController < ApplicationController
  include Azeroth::Resourceable

  helper_method :document
  helper_method :documents

  resource_for :document
end

