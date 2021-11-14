# frozen_string_literal: true

require 'spec_helper'

describe RenderingController do
  let(:parsed_response) do
    JSON.parse(response.body)
  end

  fdescribe 'GET index' do
    render_views

    let(:documents_count) { Random.rand(2..5) }

    let(:expected_content) do
      documents.map do |document|
        "<li><strong>Name:</strong>#{document.name}</li>"
      end.join("\n    ")
    end

    let!(:documents) { create_list(:document, documents_count) }

    context 'when calling on format html' do
      before do
        get :index, params: { format: :html }
      end

      it { expect(response).to be_successful }

      it { expect(response).to render_template('rendering/index') }

      it { expect(response.body).to include(expected_content) }
    end
  end

  describe 'GET show' do
    render_views

    let(:document)    { create(:document) }
    let(:document_id) { document.id }
    let(:expected_content) do
      "<p><strong>Name:</strong>#{document.name}</p>"
    end

    context 'when calling on format html' do
      before do
        get :show, params: { id: document.id, format: :html }
      end

      it { expect(response).to be_successful }

      it { expect(response).to render_template('rendering/show') }

      it { expect(response.body).to include(expected_content) }
    end
  end
end
