class ResourceRouteBuilderController
  def initialize(id: nil, document: nil)
    @id = id
    @document_params = document
  end

  private

  attr_reader :id, :document_params

  def document
    documents.find(id)
  end

  def documents
    Document.all
  end
end
