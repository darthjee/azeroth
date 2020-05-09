# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::RequestHandler::Create do
  describe '#process' do
    it_behaves_like 'a request handler', status: :created do
      let(:extra_params) do
        {
          document: {
            name: 'My Document'
          }
        }
      end

      let(:expected_json) do
        { 'name' => 'My Document' }
      end

      it 'creates entry' do
        expect { handler.process }
          .to change(Document, :count)
          .by(1)
      end
    end

    context 'with before_save option' do
      it_behaves_like 'a request handler', status: :created do
        let(:block) do
          value = 10
          proc do
            document.reference = "X-MAGIC-#{value}"
          end
        end

        let(:options_hash) do
          {
            before_save: block
          }
        end

        let(:extra_params) do
          {
            document: {
              name: 'My Document'
            }
          }
        end

        let(:expected_json) do
          { 'name' => 'My Document' }
        end

        let(:expected_json) do
          {
            'name' => 'My Document',
            'reference' => 'X-MAGIC-10'
          }
        end

        it 'creates entry' do
          expect { handler.process }
            .to change(Document, :count)
            .by(1)
        end

        it 'changes entry before saving' do
          handler.process

          expect(Document.last.reference)
            .to eq('X-MAGIC-10')
        end
      end
    end
  end

  context 'when payload is invalid' do
    it_behaves_like 'a request handler',
                    status: :unprocessable_entity do
      let(:extra_params) do
        {
          document: {
            reference: 'my_reference'
          }
        }
      end

      let(:expected_json) do
        { 'name' => nil }
      end

      it 'does not create entry' do
        expect { handler.process }
          .not_to change(Document, :count)
      end
    end
  end
end
