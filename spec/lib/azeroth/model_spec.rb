require 'spec_helper'

shared_examples 'a model wrapper' do
  describe '#name' do
    it 'returns the model name' do
      expect(subject.name).to eq('document')
    end
  end

  describe '#plural' do
    it 'returns the model name pluralized' do
      expect(subject.plural).to eq('documents')
    end
  end

  describe '#klass' do
    it 'returns the class of the model' do
      expect(subject.klass).to eq(Document)
    end
  end
end

describe Azeroth::Model do
  subject { described_class.new(input) }

  context 'when initializing with simbol' do
    let(:input) { :document }

    it_behaves_like 'a model wrapper'
  end
end
