# frozen_string_literal: true

require 'spec_helper'

describe RenderingController do
  let(:parsed_response) do
    JSON.parse(response.body)
  end

  xdescribe 'GET index' do
    let(:documents_count) { 0 }

    before do
      create_list(:document, documents_count)
    end

    context 'when calling on format json' do
      before do
        get :index, params: { format: :json }
      end

      it { expect(response).to be_successful }

      it 'returns empty text' do
        expect(response.body).to eq('')
      end

      context 'when there is a document' do
        let(:documents_count) { 1 }

        it { expect(response).to be_successful }

        it 'returns empty text' do
          expect(response.body).to eq('')
        end
      end
    end

    context 'when calling on format html' do
      before do
        get :index, params: { format: :html }
      end

      it { expect(response).to be_successful }

      it { expect(response).to render_template('documents/index') }
    end
  end

  fdescribe 'GET show' do
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
