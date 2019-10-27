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

    before do
      get :index
    end

    it { expect(response).to be_successful }

    it { expect(parsed_response).to eq([]) }

    context 'when there is a document' do
      let(:documents_count) { 1 }

      it { expect(response).to be_successful }

      it { expect(parsed_response).to eq(documents.as_json) }
    end
  end
end
