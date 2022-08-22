# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::ParamsBuilder do
  subject(:params_builder) { described_class.new(model, builder) }

  let(:model)   { Azeroth::Model.new(:document, options) }
  let(:options) { Azeroth::Options.new }
  let(:builder) { Sinclair.new(klass) }
  let(:klass)   { Class.new(ParamsBuilderController) }

  before do
    params_builder.append
  end

  describe '#append' do
    it 'adds id method' do
      expect { builder.build }
        .to add_method(:document_id).to(klass)
    end

    it 'adds params method' do
      expect { builder.build }
        .to add_method(:document_params).to(klass)
    end

    describe 'after the build' do
      let(:controller) { klass.new(id, attributes) }
      let(:document)   { create(:document) }
      let(:attributes) { document.attributes }
      let(:id)         { Random.rand(10..100) }
      let(:expected_attributes) do
        {
          "name" => document.name,
          "reference" => document.reference
        }
      end

      before { builder.build }

      context 'when requesting id' do
        it 'returns id from request path' do
          expect(controller.document_id).to eq(id)
        end
      end

      context 'when requesting params' do
        it 'returns payload' do
          expect(controller.document_params.to_h)
            .to eq(expected_attributes)
        end
      end
    end
  end
end
