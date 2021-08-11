# frozen_string_literal: true

require 'spec_helper'

describe DocumentsController do
  let(:parsed_response) do
    JSON.parse(response.body)
  end

  describe 'GET index' do
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

  describe 'GET show' do
    let(:document)    { create(:document) }
    let(:document_id) { document.id }
    let(:expected_json) do
      Document::Decorator.new(document).as_json
    end

    context 'when calling on format json' do
      before do
        get :show, params: { id: document_id, format: :json }
      end

      it { expect(response).to be_successful }

      it 'returns document json' do
        expect(parsed_response).to eq(expected_json)
      end
    end

    context 'when calling on an inexistent id' do
      let(:document_id) { :wrong_id }

      before do
        get :show, params: { id: document_id, format: :json }
      end

      it { expect(response).not_to be_successful }
      it { expect(response.status).to eq(404) }

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
    let(:payload) do
      {
        name: 'My document'
      }
    end
    let(:parameters) do
      {
        format: format,
        document: payload
      }
    end

    context 'when requesting format json' do
      let(:format) { :json }

      let(:expected_json) do
        Document::Decorator.new(Document.last).as_json
      end

      it do
        post :create, params: parameters
        expect(response).to be_successful
      end

      it 'returns created document json' do
        post :create, params: parameters
        expect(parsed_response).to eq(expected_json)
      end

      it do
        expect { post :create, params: parameters }
          .to change(Document, :count).by(1)
      end
    end

    context 'when there is validation error' do
      let(:format)  { :json }
      let(:payload) { { reference: 'x01' } }

      let(:expected_json) do
        Document::Decorator.new(Document.new(payload)).as_json
      end

      it do
        post :create, params: parameters
        expect(response).not_to be_successful
      end

      it 'returns created document json' do
        post :create, params: parameters
        expect(parsed_response).to eq(expected_json)
      end

      it do
        expect { post :create, params: parameters }
          .not_to change(Document, :count)
      end
    end
  end

  describe 'PATCH update' do
    let(:document)    { create(:document) }
    let(:document_id) { document.id }

    let(:expected_json) do
      Document::Decorator.new(Document.last).as_json
    end

    let(:payload) do
      {
        name: 'My document'
      }
    end

    let(:parameters) do
      {
        id: document_id,
        format: :json,
        document: payload
      }
    end

    it do
      patch :update, params: parameters
      expect(response).to be_successful
    end

    it 'returns updated document json' do
      patch :update, params: parameters
      expect(parsed_response).to eq(expected_json)
    end

    it do
      expect { patch :update, params: parameters }
        .to change { document.reload.name }
        .to('My document')
    end

    context 'when calling on an inexistent id' do
      let(:document_id) { :wrong_id }

      before do
        patch :update, params: parameters
      end

      it { expect(response).not_to be_successful }
      it { expect(response.status).to eq(404) }

      it 'returns empty body' do
        expect(response.body).to eq('')
      end
    end

    context 'when there is validation error' do
      let(:format)  { :json }
      let(:payload) { { name: nil } }

      let(:expected_json) do
        { 'name' => '' }
      end

      it do
        post :update, params: parameters
        expect(response).not_to be_successful
      end

      it 'returns created document json' do
        post :update, params: parameters
        expect(parsed_response).to eq(expected_json)
      end

      it 'does not update entry' do
        expect { post :create, params: parameters }
          .not_to(change { document.reload.name })
      end
    end
  end

  describe 'GET new' do
    context 'when calling with format json' do
      before { get :new, params: { format: :json } }

      let(:expected_json) do
        Document::Decorator.new(Document.new).as_json
      end

      it do
        expect(response).to be_successful
      end

      it { expect(parsed_response).to eq(expected_json) }
    end

    context 'when calling with format html' do
      before { get :new }

      it do
        expect(response).to be_successful
      end

      it { expect(response).to render_template('documents/new') }
    end
  end

  describe 'GET edit' do
    let(:document)    { create(:document) }
    let(:document_id) { document.id }

    context 'when calling on format json' do
      let(:expected_json) do
        Document::Decorator.new(document).as_json
      end

      before do
        get :edit, params: { id: document_id, format: :json }
      end

      it { expect(response).to be_successful }

      it 'returns document json' do
        expect(parsed_response).to eq(expected_json)
      end
    end

    context 'when calling on an inexistent id' do
      let(:document_id) { :wrong_id }

      before do
        get :edit, params: { id: document_id, format: :json }
      end

      it { expect(response).not_to be_successful }
      it { expect(response.status).to eq(404) }

      it 'returns empty body' do
        expect(response.body).to eq('')
      end
    end

    context 'when calling on format html' do
      before do
        get :edit, params: { id: :id, format: :html }
      end

      it { expect(response).to be_successful }

      it { expect(response).to render_template('documents/edit') }
    end
  end

  describe 'DELETE destroy' do
    let!(:document)   { create(:document) }
    let(:document_id) { document.id }

    let(:expected_json) do
      Document::Decorator.new(document).as_json
    end

    let(:parameters) do
      {
        id: document_id,
        format: :json
      }
    end

    it do
      delete :destroy, params: parameters
      expect(response).to be_successful
    end

    it do
      delete :destroy, params: parameters
      expect(parsed_response).to eq(expected_json)
    end

    it do
      expect { delete :destroy, params: parameters }
        .to change(Document, :count)
        .by(-1)
    end

    context 'when calling on an inexistent id' do
      let(:document_id) { :wrong_id }

      before do
        delete :destroy, params: parameters
      end

      it { expect(response).not_to be_successful }
      it { expect(response.status).to eq(404) }

      it 'returns empty body' do
        expect(response.body).to eq('')
      end
    end
  end
end
