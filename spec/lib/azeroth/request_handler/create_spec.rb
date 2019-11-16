# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::RequestHandler::Create do
  describe '#process' do
    it_behaves_like 'a request handler' do
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
  end
end
