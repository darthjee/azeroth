# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::RequestHandler::Index do
  describe '#process' do
    it_behaves_like 'a request handler' do
      let(:documents_count)   { 3 }
      let(:expected_resource) { Document.all }
    end

    context 'when pagination is active' do
      it_behaves_like 'a request handler' do
        let(:documents_count)   { Random.rand(21..30) }
        let(:expected_resource) { Document.all.limit(20) }
        let(:options_hash)      { { paginated: true } }
      end

      context 'when per_page is not default' do
        it_behaves_like 'a request handler' do
          let(:documents_count)   { Random.rand(21..30) }
          let(:expected_resource) { Document.all.limit(10) }
          let(:options_hash)      { { paginated: true, per_page: 10 } }
        end
      end
    end
  end
end
