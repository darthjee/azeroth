# frozen_string_literal: true

require 'spec_helper'

describe DocumentsWithErrorController do
  let(:parsed_response) do
    JSON.parse(response.body)
  end

  describe 'GET index' do
    let(:documents_count) { 0 }

    before do
      create_list(:document, documents_count)
    end

    context 'when calling on format json' do
      it do
        expect { get :index, params: { format: :json } }
          .to raise_error(AbstractController::ActionNotFound)
      end

      context 'when there is a document' do
        let(:documents_count) { 1 }

        it do
          expect { get :index, params: { format: :json } }
            .to raise_error(AbstractController::ActionNotFound)
        end
      end
    end

    context 'when calling on format html' do
      it do
        expect { get :index, params: { format: :html } }
          .to raise_error(AbstractController::ActionNotFound)
      end
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

      let(:expected_body) do
        Document::DecoratorWithError.new(Document.new(payload)).to_json
      end

      it do
        post :create, params: parameters
        expect(response).not_to be_successful
      end

      it 'returns created document json' do
        post :create, params: parameters
        expect(response.body).to eq(expected_body)
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

    let(:expected_body) do
      Document.last.to_json
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

      expect(JSON.parse(response.body))
        .to eq(JSON.parse(expected_body))
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
        {
          'id' => document.id,
          'name' => '',
          'reference' => nil
        }
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
        expect { post :update, params: parameters }
          .not_to(change { document.reload.name })
      end
    end
  end
end
