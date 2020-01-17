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
            .not_to change { document.reload.name }
        end
      end
    end
  end
end
