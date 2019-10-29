# frozen_string_literal: true

class DocumentsController < ApplicationController
  include Azeroth::Resourceable

  resource_for :document

  private

  def render_basic
    action = params[:action]
    respond_to do |format|
      format.json { render json: send("#{action}_resource") }
      format.html { action }
    end
  end
end
