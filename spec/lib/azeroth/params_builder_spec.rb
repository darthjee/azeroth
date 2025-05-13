# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::ParamsBuilder do
  subject(:params_builder) do
    described_class.new(model: model, builder: builder)
  end

  let(:model)        { Azeroth::Model.new(:document, options) }
  let(:options)      { Azeroth::Options.new(options_hash) }
  let(:options_hash) { {} }
  let(:builder)      { Sinclair.new(klass) }
  let(:klass)        { Class.new(ParamsBuilderController) }
  let(:controller)   { klass.new(id, attributes) }
  let(:attributes)   { document.attributes }
  let(:document)     { create(:document) }
  let(:id)           { Random.rand(10..100) }

  before do
    params_builder.append
  end

  describe '#append' do
    context "when no options are given" do
      it 'adds id method' do
        expect { builder.build }
          .to add_method(:document_id).to(klass)
      end

      it 'adds params method' do
        expect { builder.build }
          .to add_method(:document_params).to(klass)
      end

      describe 'after the build' do
        let(:expected_attributes) do
          {
            'name' => document.name,
            'reference' => document.reference
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

  context "when no options are given" do
    let(:options_hash) { { param_key: :document_id }}
    let(:controller)   { klass.new(id, attributes, param_id: :document_id) }

    before { builder.build }

    context 'when requesting id' do
      it 'returns id from request path' do
        expect(controller.document_id).to eq(id)
      end
    end
  end
end
