# frozen_string_literal: true

class DocumentsController < ApplicationController
  def index
    render json: Document.all.to_json
  end
end
