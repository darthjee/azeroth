# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::RequestHandler::Update do
  describe '#process' do
    let!(:document) { create(:document) }

    it_behaves_like 'a request handler' do
      let(:expected_resource) { document }

      let(:extra_params) do
        {
          id: document.id,
          document: {
            name: 'New Name'
          }
        }
      end

      let(:expected_json) do
        decorator.as_json.merge('name' => 'New Name')
      end

      it 'updates the values' do
        expect { handler.process }
          .to change { document.reload.name }
          .from(document.name)
          .to('New Name')
      end
    end

    context 'when update_with option is given' do
      context 'with block' do
        it_behaves_like 'a request handler' do
          let(:block) do
            proc do
              document.assign_attributes(document_params)
              document.name = "#{document.name}!"
              document.save
            end
          end

          let(:options_hash) do
            {
              update_with: block
            }
          end

          let(:expected_resource) { document }

          let(:extra_params) do
            {
              id: document.id,
              document: {
                name: 'New Name'
              }
            }
          end

          let(:expected_json) do
            {
              'name' => 'New Name!'
            }
          end

          it 'updates the values given by request' do
            expect { handler.process }
              .to change { document.reload.name }
              .from(document.name)
              .to('New Name!')
          end
        end
      end

      context 'with symbol' do
        it_behaves_like 'a request handler' do
          let(:options_hash) do
            {
              update_with: :add_bang_name
            }
          end

          let(:expected_resource) { document }

          let(:extra_params) do
            {
              id: document.id,
              document: {
                name: 'New Name'
              }
            }
          end

          let(:expected_json) do
            {
              'name' => 'New Name!'
            }
          end

          it 'updates the values given by request' do
            expect { handler.process }
              .to change { document.reload.name }
              .from(document.name)
              .to('New Name!')
          end
        end
      end

      context 'with string' do
        it_behaves_like 'a request handler' do
          let(:options_hash) do
            {
              update_with: 'add_bang_name'
            }
          end

          let(:expected_resource) { document }

          let(:extra_params) do
            {
              id: document.id,
              document: {
                name: 'New Name'
              }
            }
          end

          let(:expected_json) do
            {
              'name' => 'New Name!'
            }
          end

          it 'updates the values given by request' do
            expect { handler.process }
              .to change { document.reload.name }
              .from(document.name)
              .to('New Name!')
          end
        end
      end
    end

    context 'with before_save block option' do
      it_behaves_like 'a request handler' do
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

        let(:expected_resource) { document }

        let(:extra_params) do
          {
            id: document.id,
            document: {
              name: 'New Name'
            }
          }
        end

        let(:expected_json) do
          {
            'name' => 'New Name',
            'reference' => 'X-MAGIC-10'
          }
        end

        it 'updates the values given by request' do
          expect { handler.process }
            .to change { document.reload.name }
            .from(document.name)
            .to('New Name')
        end

        it 'updates the values done by before_save' do
          expect { handler.process }
            .to change { document.reload.reference }
            .from(nil)
            .to('X-MAGIC-10')
        end
      end
    end

    context 'with before_save symbol option' do
      it_behaves_like 'a request handler' do
        let(:options_hash) do
          {
            before_save: :add_magic_reference
          }
        end

        let(:expected_resource) { document }

        let(:extra_params) do
          {
            id: document.id,
            document: {
              name: 'New Name'
            }
          }
        end

        let(:expected_json) do
          {
            'name' => 'New Name',
            'reference' => 'X-MAGIC-15'
          }
        end

        it 'updates the values given by request' do
          expect { handler.process }
            .to change { document.reload.name }
            .from(document.name)
            .to('New Name')
        end

        it 'updates the values done by before_save' do
          expect { handler.process }
            .to change { document.reload.reference }
            .from(nil)
            .to('X-MAGIC-15')
        end
      end
    end

    context 'when payload is invalid' do
      it_behaves_like 'a request handler',
                      status: :unprocessable_entity do
        let(:expected_resource) { document }
        let(:extra_params) do
          {
            id: document.id,
            document: {
              name: nil
            }
          }
        end

        let(:expected_json) do
          { 'name' => nil }
        end

        it 'does not update entry' do
          expect { handler.process }
            .not_to(change { document.reload.name })
        end
      end
    end
  end
end
