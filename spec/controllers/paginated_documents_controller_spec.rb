# frozen_string_literal: true

require 'spec_helper'

describe PaginatedDocumentsController do
  let(:parsed_response) do
    JSON.parse(response.body)
  end

  describe 'GET index' do
    let(:documents_count) { 0 }
    let!(:documents) do
      create_list(:document, documents_count)
    end

    let(:expected_json) do
      Document::Decorator.new(documents).as_json
    end

    context 'when calling on format json' do
      let(:parameters) { {} }

      before do
        get :index, params: parameters.merge(format: :json)
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
            .to have(20).elements
        end

        context 'when page is given' do
          let(:parameters) { { page: 2 } }

          it { expect(response).to be_successful }

          it 'returns paginated documents' do
            expect(parsed_response)
              .not_to have(documents_count).elements
          end

          it 'returns full page of documents' do
            expect(parsed_response)
              .to have(documents_count - 20)
              .elements
          end
        end

        context 'when per_page is given' do
          let(:per_page)   { Random.rand(5..15) }
          let(:parameters) { { per_page: per_page } }

          it { expect(response).to be_successful }

          it 'returns paginated documents' do
            expect(parsed_response)
              .not_to have(documents_count).elements
          end

          it 'returns full page of documents' do
            expect(parsed_response)
              .to have(per_page)
              .elements
          end
        end
      end
    end
  end
end
