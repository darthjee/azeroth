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

        it 'adds total pages header' do
          handler.process
          expect(controller_headers['pages']).to eq(2)
        end

        it 'adds current page header' do
          handler.process
          expect(controller_headers['page']).to eq(1)
        end

        it 'adds per page header' do
          handler.process
          expect(controller_headers['per_page']).to eq(20)
        end
      end

      context 'when page is given' do
        it_behaves_like 'a request handler' do
          let(:documents_count)   { Random.rand(41..50) }
          let(:expected_resource) { Document.all.offset(20).limit(20) }
          let(:options_hash)      { { paginated: true } }
          let(:extra_params)      { { page: '2' } }

          it 'adds total pages header' do
            handler.process
            expect(controller_headers['pages']).to eq(3)
          end

          it 'adds current page header' do
            handler.process
            expect(controller_headers['page']).to eq(2)
          end

          it 'adds per page header' do
            handler.process
            expect(controller_headers['per_page']).to eq(20)
          end
        end
      end

      context 'when third page is given' do
        it_behaves_like 'a request handler' do
          let(:documents_count)   { Random.rand(41..50) }
          let(:expected_resource) { Document.all.offset(40) }
          let(:options_hash)      { { paginated: true } }
          let(:extra_params)      { { page: '3' } }

          it 'adds total pages header' do
            handler.process
            expect(controller_headers['pages']).to eq(3)
          end

          it 'adds current page header' do
            handler.process
            expect(controller_headers['page']).to eq(3)
          end

          it 'adds per page header' do
            handler.process
            expect(controller_headers['per_page']).to eq(20)
          end
        end
      end

      context 'when per_page is not default' do
        it_behaves_like 'a request handler' do
          let(:documents_count)   { Random.rand(21..30) }
          let(:expected_resource) { Document.all.limit(10) }
          let(:options_hash)      { { paginated: true, per_page: 10 } }

          it 'adds total pages header' do
            handler.process
            expect(controller_headers['pages']).to eq(3)
          end

          it 'adds current page header' do
            handler.process
            expect(controller_headers['page']).to eq(1)
          end

          it 'adds per page header' do
            handler.process
            expect(controller_headers['per_page']).to eq(10)
          end
        end
      end

      context 'when per page is given in params' do
        it_behaves_like 'a request handler' do
          let(:documents_count)   { Random.rand(41..50) }
          let(:expected_resource) { Document.all.offset(10).limit(10) }
          let(:options_hash)      { { paginated: true, per_page: 15 } }
          let(:extra_params)      { { page: '2', per_page: '10' } }

          it 'adds total pages header' do
            handler.process
            expect(controller_headers['pages']).to eq(5)
          end

          it 'adds current page header' do
            handler.process
            expect(controller_headers['page']).to eq(2)
          end

          it 'adds per page header' do
            handler.process
            expect(controller_headers['per_page']).to eq(10)
          end
        end
      end
    end
  end
end
