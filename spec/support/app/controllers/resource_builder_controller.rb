class ResourceBuilderController
  def initialize(document_id: nil)
    @document_id = document_id
  end

  private

  attr_reader :document_id
end
