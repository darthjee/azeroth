# frozen_string_literal: true

require 'spec_helper'

describe DocumentsController do
  let(:parsed_response) do
    JSON.parse(response.body)
  end

  describe 'GET index' do
    let(:documents_count) { 0 }
    let!(:documents) do
      documents_count.times.map do
        Document.create
      end
    end

    context 'when calling on format json' do
      before do
        get :index, params: { format: :json }
      end

      it { expect(response).to be_successful }

      it 'returns empty array' do
        expect(parsed_response).to eq([])
      end

      context 'when there is a document' do
        let(:documents_count) { 1 }

        it { expect(response).to be_successful }

        it 'renders documents json' do
          expect(parsed_response).to eq(documents.as_json)
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

  describe 'GET show' do
    let(:document)    { Document.create }
    let(:document_id) { document.id }

    context 'when calling on format json' do
      before do
        get :show, params: { id: document_id, format: :json }
      end

      it { expect(response).to be_successful }

      it 'returns document json' do
        expect(parsed_response).to eq(document.as_json)
      end
    end

    context 'when calling on an inexistent id' do
      let(:document_id) { :wrong_id }

      before do
        get :show, params: { id: document_id, format: :json }
      end

      it { expect(response).not_to be_successful }

      it 'returns empty body' do
        expect(response.body).to eq('')
      end
    end

    context 'when calling on format html' do
      before do
        get :show, params: { id: :id, format: :html }
      end

      it { expect(response).to be_successful }

      it { expect(response).to render_template('documents/show') }
    end
  end

  describe 'POST create' do
    let(:parameters) do
      {
        document: {
          name: 'My document'
        }
      }
    end

    it do
      post :create, params: parameters
      expect(response).to be_successful
    end

    it 'returns created document json' do
      post :create, params: parameters
      expect(parsed_response).to eq(Document.last.as_json)
    end

    it do
      expect { post :create, params: parameters }
        .to change(Document, :count).by(1)
    end
  end

  describe 'PATCH update' do
    let(:document)    { Document.create }
    let(:document_id) { document.id }

    let(:parameters) do
      {
        id: document_id,
        document: {
          name: 'My document'
        }
      }
    end

    it do
      patch :update, params: parameters
      expect(response).to be_successful
    end

    it 'returns created document json' do
      patch :update, params: parameters
      expect(parsed_response).to eq(Document.last.as_json)
    end

    it do
      expect { patch :update, params: parameters }
        .to change { document.reload.name }
        .from(nil).to('My document')
    end

    context 'when calling on an inexistent id' do
      let(:document_id) { :wrong_id }

      before do
        patch :update, params: parameters
      end

      it { expect(response).not_to be_successful }

      it 'returns empty body' do
        expect(response.body).to eq('')
      end
    end
  end
end
