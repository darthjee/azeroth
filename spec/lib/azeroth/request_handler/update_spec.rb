# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::RequestHandler::Update do
  describe '#process' do
    it_behaves_like 'a request handler', :update do
      let(:expected_resource) { document }
      let!(:document)         { create(:document) }

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
  end
end