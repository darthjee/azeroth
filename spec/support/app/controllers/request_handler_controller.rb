# frozen_string_literal: true

class RequestHandlerController < ActionController::Base
  private

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
    document.reference = 'X-MAGIC-15'
  end

  def add_magic_reference_and_trigger
    document.update(reference: 'X-MAGIC-15')
    Worker.perform(document.id)
  end

  def build_magic_document
    documents.where(reference: 'X-MAGIC-15')
             .build(document_params)
  end

  def add_bang_name
    document.assign_attributes(document_params)
    document.name = "#{document.name}!"
    document.save
  end
end
