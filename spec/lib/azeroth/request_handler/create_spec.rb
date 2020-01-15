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
