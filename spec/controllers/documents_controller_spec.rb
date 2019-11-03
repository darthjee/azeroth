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

      it { expect(parsed_response).to eq([]) }

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
    let(:document) { Document.create }

    context 'when calling on format json' do
      before do
        get :show, params: { id: document.id, format: :json }
      end

      it { expect(response).to be_successful }

      it { expect(parsed_response).to eq(document.as_json) }
    end

    context 'when calling on format html' do
      before do
        get :show, params: { id: document.id, format: :html }
      end

      it { expect(response).to be_successful }

      it { expect(response).to render_template('documents/show') }
    end
  end
end
