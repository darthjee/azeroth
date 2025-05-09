# frozen_string_literal: true

require 'spec_helper'

describe PaginatedDocumentsController, :controller do
  describe 'yard' do
    describe 'GET index' do
      before { create_list(:document, 30) }

      it 'list documents with pagination page' do
        get '/paginated_documents.json'

        documents = JSON.parse(response.body)
        expect(documents)
          .to have(20).items

        expect(response.headers['pages']).to eq(2)
        expect(response.headers['per_page']).to eq(20)
        expect(response.headers['page']).to eq(1)

        get '/paginated_documents.json?page=2'

        documents = JSON.parse(response.body)
        expect(documents)
          .to have(10).items

        expect(response.headers['pages']).to eq(2)
        expect(response.headers['per_page']).to eq(20)
        expect(response.headers['page']).to eq(2)
      end
    end
  end
end
