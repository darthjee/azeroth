# frozen_string_literal: true

require 'spec_helper'

describe PaginatedDocumentsController do
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

      context 'when there are more documents than expected pagination' do
        let(:documents_count) { Random.rand(21..30) }

        it { expect(response).to be_successful }

        it 'returns paginated documents' do
          expect(parsed_response)
            .not_to have(documents_count).elements
        end

        it 'returns full page of documents' do
          expect(parsed_response)
            .not_to have(20).elements
        end
      end
    end
  end
end
