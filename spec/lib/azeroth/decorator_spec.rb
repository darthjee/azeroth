# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::Decorator do
  subject(:decorator) { DummyModel::Decorator.new(object) }

  let(:model)  { build(:dummy_model) }
  let(:object) { model }

  describe '#as_json' do
    context 'when object is just a model' do
      let(:expected_json) do
        {
          name: "#{model.first_name} #{model.last_name}",
          age: model.age,
          pokemon: model.favorite_pokemon
        }.stringify_keys
      end

      it 'returns meta data defined json' do
        expect(decorator.as_json).to eq(expected_json)
      end

      context 'when conditional attibute is exposed' do
        let(:model) { build(:dummy_model, first_name: nil) }

        let(:expected_json) do
          {
            name: model.last_name,
            age: model.age,
            pokemon: model.favorite_pokemon,
            errors: {
              first_name: ["can't be blank"]
            }
          }.stringify_keys
        end

        it 'include the conditional attributes' do
          expect(decorator.as_json).to eq(expected_json)
        end
      end
    end

    context 'when object is an array' do
      let(:object) { [model, other_model] }

      let(:other_model) do
        build(
          :dummy_model,
          first_name: 'dum',
          age: 65,
          favorite_pokemon: :bulbasaur
        )
      end

      let(:expected_json) do
        [
          {
            name: "#{model.first_name} #{model.last_name}",
            age: model.age,
            pokemon: model.favorite_pokemon
          }, {
            name: "#{other_model.first_name} #{other_model.last_name}",
            age: other_model.age,
            pokemon: other_model.favorite_pokemon
          }
        ].map(&:stringify_keys)
      end

      it 'returns meta data defined json' do
        expect(decorator.as_json).to eq(expected_json)
      end
    end

    context 'when object is just an active record model' do
      subject(:decorator) { Document::Decorator.new(object) }

      let(:reference) { SecureRandom.uuid }
      let!(:model)    { create(:document, reference: reference) }

      let(:expected_json) do
        {
          name: model.name
        }.stringify_keys
      end

      it 'returns meta data defined json' do
        expect(decorator.as_json).to eq(expected_json)
      end
    end

    context 'when object is an active record relation' do
      subject(:decorator) { Document::Decorator.new(object) }

      let(:reference)    { SecureRandom.uuid }
      let!(:model)       { create(:document, reference: reference) }
      let(:object)       { Document.where(reference: reference) }
      let!(:other_model) { create(:document, reference: reference) }

      let(:expected_json) do
        [
          {
            name: model.name
          }, {
            name: other_model.name
          }
        ].map(&:stringify_keys)
      end

      it 'returns meta data defined json' do
        expect(decorator.as_json).to eq(expected_json)
      end
    end

    context 'with decotator for model with validation' do
      subject(:decorator) do
        Document::DecoratorWithError.new(object)
      end

      context 'with valid model' do
        let(:object) { build(:document) }

        let(:expected_json) do
          {
            name: object.name
          }.stringify_keys
        end

        it 'returns meta data defined json' do
          expect(decorator.as_json).to eq(expected_json)
        end
      end

      context 'with invalid model' do
        let(:object) { build(:document, name: nil) }

        let(:expected_json) do
          {
            name: nil,
            errors: {
              name: ["can't be blank"]
            }
          }.stringify_keys
        end

        it 'returns meta data defined json' do
          expect(decorator.as_json).to eq(expected_json)
        end
      end
    end

    context 'when decorator decorates relation' do
      context 'when relation object has no decorator' do
        subject(:decorator) do
          Product::DecoratorWithFactory.new(product)
        end

        let(:product) { create(:product) }
        let(:factory) { product.factory }

        let(:expected_json) do
          {
            name: product.name,
            factory: factory.as_json
          }.stringify_keys
        end

        it 'exposes relation' do
          expect(decorator.as_json).to eq(expected_json)
        end
      end

      context 'when relation object has decorator' do
        subject(:decorator) do
          Factory::DecoratorWithProduct.new(factory)
        end

        let(:main_product) { create(:product) }
        let(:factory)      { main_product.factory }

        let(:expected_json) do
          {
            name: factory.name,
            main_product: {
              name: main_product.name
            }
          }.stringify_keys
        end

        it 'exposes relation' do
          expect(decorator.as_json).to eq(expected_json)
        end
      end
    end
  end

  describe '#method_missing' do
    subject(:decorator) { decorator_class.new(object) }

    let(:decorator_class) { Class.new(described_class) }
    let(:model) { build(:dummy_model) }

    it 'delegates methods to object' do
      expect(decorator.first_name).not_to be_nil
    end

    context 'when object does not respond to method' do
      it do
        expect { decorator.bad_method }
          .to raise_error(NoMethodError)
      end
    end
  end

  describe '#respond_to_missing?' do
    subject(:decorator) { decorator_class.new(object) }

    let(:decorator_class) { Class.new(described_class) }
    let(:model) { build(:dummy_model) }

    context 'when object responds to it' do
      it do
        expect(decorator)
          .to respond_to(:first_name)
      end
    end

    context 'when method is private' do
      it do
        expect(decorator)
          .not_to respond_to(:private_name)
      end
    end

    context 'when method is private and passing include_private' do
      # rubocop:disable RSpec/PredicateMatcher
      it do
        expect(decorator.respond_to?(:private_name, true))
          .to be_truthy
      end
      # rubocop:enable RSpec/PredicateMatcher
    end

    context 'when object does not respond to it' do
      it do
        expect(decorator)
          .not_to respond_to(:no_name)
      end
    end
  end
end
