# frozen_string_literal: true

require 'spec_helper'

shared_examples 'a model wrapper' do
  describe '#name' do
    it 'returns the model name' do
      expect(model.name).to eq('document')
    end
  end

  describe '#plural' do
    it 'returns the model name pluralized' do
      expect(model.plural).to eq('documents')
    end
  end

  describe '#klass' do
    it 'returns the class of the model' do
      expect(model.klass).to eq(Document)
    end
  end
end

describe Azeroth::Model do
  subject(:model) { described_class.new(input, options) }

  let(:options)      { Azeroth::Options.new(options_hash) }
  let(:options_hash) { {} }

  context 'when initializing with symbol' do
    let(:input) { :document }

    it_behaves_like 'a model wrapper'
  end

  context 'when initializing with string' do
    let(:input) { 'document' }

    it_behaves_like 'a model wrapper'
  end

  context 'when initializing with model' do
    let(:input) { Document }

    it_behaves_like 'a model wrapper'
  end

  describe '#decorate' do
    context 'when model has a decorator' do
      let(:input)     { :document }
      let(:reference) { SecureRandom.uuid }
      let!(:object)   { create(:document, reference: reference) }

      context 'when object is just a model and has decorator' do
        let!(:object) { create(:document, reference: reference) }

        let(:expected_json) do
          {
            name: object.name
          }.stringify_keys
        end

        it 'returns meta data defined json' do
          expect(model.decorate(object)).to eq(expected_json)
        end
      end

      context 'when object is an active record relation' do
        let(:relation)      { Document.where(reference: reference) }
        let!(:other_object) { create(:document, reference: reference) }

        let(:expected_json) do
          [
            {
              name: object.name
            }, {
              name: other_object.name
            }
          ].map(&:stringify_keys)
        end

        it 'returns meta data defined json' do
          expect(model.decorate(relation)).to eq(expected_json)
        end
      end
    end

    context 'when model is an active record that does not have a decorator' do
      let(:input)     { Class.new(User) }
      let(:reference) { SecureRandom.uuid }
      let!(:object)   { create(:user, reference: reference) }

      context 'when object is just a model' do
        it 'returns regular as_json' do
          expect(model.decorate(object)).to eq(object.as_json)
        end
      end

      context 'when object is an active record relation' do
        let(:relation) { User.where(reference: reference) }

        before { create(:user, reference: reference) }

        it 'returns regular as_json' do
          expect(model.decorate(relation)).to eq(relation.as_json)
        end
      end
    end

    context 'when model is an active model that does not have a decorator' do
      let(:input) do
        Class.new do
          include ActiveModel::Model
          attr_accessor :id, :name
        end
      end

      let(:object) { input.new(id: 1, name: 'my name') }

      it 'returns regular as_json' do
        expect(model.decorate(object)).to eq(object.as_json)
      end
    end

    context 'when model has a decorator and option decorator is false' do
      let(:input)        { :document }
      let(:reference)    { SecureRandom.uuid }
      let(:object)       { create(:document, reference: reference) }
      let(:options_hash) { { decorator: false } }

      context 'when object is just a model and has decorator' do
        let!(:object) { create(:document, reference: reference) }

        let(:expected_json) do
          object.as_json
        end

        it 'object.as_json' do
          expect(model.decorate(object)).to eq(expected_json)
        end
      end
    end

    context 'when model has a decorator and option decorator is a decorator' do
      let(:input)        { :document }
      let(:reference)    { SecureRandom.uuid }
      let(:object)       { create(:document, reference: reference) }
      let(:options_hash) { { decorator: Document::DecoratorWithError } }

      context 'when object is just a model and has decorator' do
        let!(:object) { Document.new }

        let(:expected_json) do
          {
            name: nil,
            errors: {
              name: ["can't be blank"]
            }
          }.deep_stringify_keys
        end

        it 'object.as_json' do
          expect(model.decorate(object)).to eq(expected_json)
        end
      end
    end
  end
end
