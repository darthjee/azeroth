# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::RoutesBuilder do
  subject(:routes_builder) do
    described_class.new(model, builder, options)
  end

  let(:model)        { Azeroth::Model.new(:document) }
  let(:builder)      { Sinclair.new(klass) }
  let(:klass)        { Class.new(RoutesBuilderController) }
  let(:instance)     { klass.new(params) }
  let(:params)       { {} }
  let(:options)      { Azeroth::Options.new(options_hash) }
  let(:options_hash) { {} }

  before do
    routes_builder.append
    10.times { Document.create }
  end

  describe '#append' do
    before { routes_builder.append }

    it 'adds index route' do
      expect do
        builder.build
      end.to add_method(:index).to(klass.new)
    end

    describe 'when calling index' do
      before { builder.build }

      it 'returns the index object' do
        expect(instance.perform(:index)).to eq(json: 'index_json')
      end
    end
  end
end
