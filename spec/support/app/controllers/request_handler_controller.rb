# frozen_string_literal: true

class RequestHandlerController < ActionController::Base
  def document_params
    params.require(:document).permit(:name)
  end

  def documents
    Document.all
  end

  def document
    @document ||= documents.find(params.require(:id))
  end

  def add_magic_reference
    document.reference = "X-MAGIC-15"
  end
end
