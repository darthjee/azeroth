# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::RequestHandler::Destroy do
  describe '#process' do
    it_behaves_like 'a request handler' do
      let(:expected_resource) { document }
      let!(:document)         { create(:document) }

      let(:extra_params) { { id: document.id } }

      it 'updates the values' do
        expect { handler.process }
          .to change(Document, :count)
          .by(-1)
      end
    end
  end
end
