# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::ResourceBuilder do
  subject(:resource_builder) do
    described_class.new(model: model, builder: builder)
  end

  let(:model)   { Azeroth::Model.new(:document, options) }
  let(:options) { Azeroth::Options.new }
  let(:builder) { Sinclair.new(klass) }
  let(:klass)   { Class.new(ResourceBuilderController) }

  before do
    resource_builder.append
    create_list(:document, 10)
  end

  describe '#append' do
    it 'adds the listing method' do
      expect { builder.build }
        .to change { klass.new.respond_to?(:documents) }
        .to(true)
    end

    it 'adds the fetching method' do
      expect { builder.build }
        .to change { klass.new.respond_to?(:document) }
        .to(true)
    end

    describe 'after the build' do
      let(:controller) { klass.new(document_id: document.id) }
      let(:document)   { create(:document) }

      before { builder.build }

      context 'when requesting the list of documents' do
        it 'returns the list of documents' do
          expect(controller.documents).to eq(Document.all)
        end
      end

      context 'when requesting one document' do
        it 'returns the requested document' do
          expect(controller.document).to eq(document)
        end
      end
    end
  end
end
