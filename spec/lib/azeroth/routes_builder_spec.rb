require 'spec_helper'

describe Azeroth::RoutesBuilder do
  subject { described_class.new(model, builder) }

  let(:model)    { Azeroth::Model.new(:document) }
  let(:builder)  { Sinclair.new(klass) }
  let(:klass)    { Class.new(RoutesBuilderController) }
  let(:instance) { klass.new(params) }
  let(:params)   { {} }

  before do
    subject.append
    10.times { Document.create }
  end

  describe '#append' do
    before { subject.append }

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
