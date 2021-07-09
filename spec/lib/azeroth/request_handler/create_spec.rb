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

    context 'with before_save block option' do
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

    context 'with before_save symbol option' do
      it_behaves_like 'a request handler', status: :created do
        let(:options_hash) do
          {
            before_save: :add_magic_reference
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
          {
            'name' => 'My Document',
            'reference' => 'X-MAGIC-15'
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
            .to eq('X-MAGIC-15')
        end
      end
    end

    context 'with after_save block option' do
      it_behaves_like 'a request handler', status: :created do
        let(:block) do
          value = 10
          proc do
            document.update(reference: "X-MAGIC-#{value}")
            Worker.perform(document.id)
          end
        end

        let(:options_hash) do
          {
            after_save: block
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
          {
            'name' => 'My Document',
            'reference' => 'X-MAGIC-10'
          }
        end

        before do
          allow(Worker).to receive(:perform)
        end

        it 'creates entry' do
          expect { handler.process }
            .to change(Document, :count)
            .by(1)
        end

        it 'trigger workers after saving' do
          handler.process

          expect(Worker).to have_received(:perform)
            .with(Document.last.id)
        end

        it 'changes entry after saving' do
          handler.process

          expect(Document.last.reference)
            .to eq('X-MAGIC-10')
        end
      end
    end

    context 'with before_save symbol option' do
      it_behaves_like 'a request handler', status: :created do
        let(:options_hash) do
          {
            after_save: :add_magic_reference_and_trigger
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
          {
            'name' => 'My Document',
            'reference' => 'X-MAGIC-15'
          }
        end

        before do
          allow(Worker).to receive(:perform)
        end

        it 'creates entry' do
          expect { handler.process }
            .to change(Document, :count)
            .by(1)
        end

        it 'trigger workers after saving' do
          handler.process

          expect(Worker).to have_received(:perform)
            .with(Document.last.id)
        end

        it 'changes entry after saving' do
          handler.process

          expect(Document.last.reference)
            .to eq('X-MAGIC-15')
        end
      end
    end
  end

  context 'with build_with as symbol' do
    it_behaves_like 'a request handler', status: :created do
      let(:options_hash) do
        {
          build_with: :build_magic_document
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
        {
          'name' => 'My Document',
          'reference' => 'X-MAGIC-15'
        }
      end

      it 'creates entry' do
        expect { handler.process }
          .to change(Document, :count)
          .by(1)
      end

      it 'builds entity with custom method' do
        handler.process

        expect(Document.last.reference)
          .to eq('X-MAGIC-15')
      end
    end
  end

  context 'with build_with as block' do
    it_behaves_like 'a request handler', status: :created do
      let(:block) do
        proc do
          documents.where(reference: 'X-MAGIC-20')
                   .build(document_params)
        end
      end

      let(:options_hash) do
        {
          build_with: block
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
        {
          'name' => 'My Document',
          'reference' => 'X-MAGIC-20'
        }
      end

      it 'creates entry' do
        expect { handler.process }
          .to change(Document, :count)
          .by(1)
      end

      it 'builds entity with custom method' do
        handler.process

        expect(Document.last.reference)
          .to eq('X-MAGIC-20')
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
