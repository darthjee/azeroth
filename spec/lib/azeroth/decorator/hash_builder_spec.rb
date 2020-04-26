# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::Decorator::HashBuilder do
  subject(:builder) { described_class.new(decorator) }

  let(:decorator_class) { DummyModel::Decorator }
  let(:decorator)       { decorator_class.new(model) }
  let(:model)           { build(:dummy_model) }

  describe '#as_json' do
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
        }.deep_stringify_keys
      end

      it 'include the conditional attributes' do
        expect(decorator.as_json).to eq(expected_json)
      end
    end

    context 'when decorator has an expose block conditional' do
      let(:decorator_class) { Document::Decorator }
      let(:model)           { create(:document) }

      let(:expected_json) do
        {
          name: model.name
        }.stringify_keys
      end

      it 'returns meta data defined json' do
        expect(decorator.as_json).to eq(expected_json)
      end

      context 'when conditional returns true' do
        let(:model) { create(:document, reference: 'X-MAGIC-01') }

        let(:expected_json) do
          {
            name: model.name,
            reference: 'X-MAGIC-01'
          }.stringify_keys
        end

        it 'returns meta data defined json' do
          expect(decorator.as_json).to eq(expected_json)
        end
      end
    end
  end
end
