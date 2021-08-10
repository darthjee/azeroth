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

      context 'when page is given' do
        it_behaves_like 'a request handler' do
          let(:documents_count)   { Random.rand(41..50) }
          let(:expected_resource) { Document.all.offset(20).limit(20) }
          let(:options_hash)      { { paginated: true } }
          let(:extra_params)      { { page: 2 } }
        end
      end

      context 'when third page is given' do
        it_behaves_like 'a request handler' do
          let(:documents_count)   { Random.rand(41..50) }
          let(:expected_resource) { Document.all.offset(40) }
          let(:options_hash)      { { paginated: true } }
          let(:extra_params)      { { page: 3 } }
        end
      end

      context 'when per_page is not default' do
        it_behaves_like 'a request handler' do
          let(:documents_count)   { Random.rand(21..30) }
          let(:expected_resource) { Document.all.limit(10) }
          let(:options_hash)      { { paginated: true, per_page: 10 } }
        end
      end

      context 'when per page is given in params' do
        it_behaves_like 'a request handler' do
          let(:documents_count)   { Random.rand(41..50) }
          let(:expected_resource) { Document.all.offset(15).limit(15) }
          let(:options_hash)      { { paginated: true, per_page: 10 } }
          let(:extra_params)      { { page: 2, per_page: 15 } }
        end
      end
    end
  end
end
