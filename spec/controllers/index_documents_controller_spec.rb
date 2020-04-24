# frozen_string_literal: true

require 'spec_helper'

describe IndexDocumentsController do
  let(:parsed_response) do
    JSON.parse(response.body)
  end

  describe 'GET index' do
    let(:documents_count) { 0 }
    let!(:documents) do
      documents_count.times.map { create(:document) }
    end

    let(:expected_json) do
      Document::Decorator.new(documents).as_json
    end

    context 'when calling on format json' do
      before do
        get :index, params: { format: :json }
      end

      it { expect(response).to be_successful }

      it 'returns empty array' do
        expect(parsed_response).to eq(expected_json)
      end

      context 'when there is a document' do
        let(:documents_count) { 1 }

        it { expect(response).to be_successful }

        it 'renders documents json' do
          expect(parsed_response).to eq(expected_json)
        end
      end
    end
  end

  describe 'GET show' do
    let(:document)    { create(:document) }
    let(:document_id) { document.id }
    let(:parameters)  { { id: document_id, format: :json } }


    context 'when calling on format json' do
      it do
        expect { get :show, params: parameters }
          .to raise_error(AbstractController::ActionNotFound)
      end
    end

    context 'when calling on an inexistent id' do
      let(:document_id) { :wrong_id }

      it do
        expect { get :show, params: parameters }
          .to raise_error(AbstractController::ActionNotFound)
      end
    end

    context 'when calling on format html' do
      it do
        expect { get :show, params: parameters }
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

      it do
        expect { get :create, params: parameters }
          .to raise_error(AbstractController::ActionNotFound)
      end
    end
  end

  describe 'PATCH update' do
    let(:document)    { create(:document) }
    let(:document_id) { document.id }

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
      expect { get :update, params: parameters }
        .to raise_error(AbstractController::ActionNotFound)
    end
  end

  describe 'GET new' do
    context 'when calling with format json' do
      it do
        expect { get :new, params: { format: :json } }
          .to raise_error(AbstractController::ActionNotFound)
      end
    end

    context 'when calling with format html' do
      it do
        expect { get :new, params: { format: :json } }
          .to raise_error(AbstractController::ActionNotFound)
      end
    end
  end

  describe 'GET edit' do
    let(:document)    { create(:document) }
    let(:document_id) { document.id }

    context 'when calling on format json' do
      let(:parameters) { { id: document_id, format: :json } }

      it do
        expect { get :edit, params: parameters }
          .to raise_error(AbstractController::ActionNotFound)
      end
    end

    context 'when calling on format html' do
      let(:parameters) { { id: document_id, format: :html } }

      it do
        expect { get :edit, params: parameters }
          .to raise_error(AbstractController::ActionNotFound)
      end
    end
  end
end
