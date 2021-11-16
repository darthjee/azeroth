# frozen_string_literal: true

class RenderingController < ApplicationController
  include Azeroth::Resourceable

  resource_for :document
end
