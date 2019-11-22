# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::Decorator::HashBuilder do
  subject(:builder) { described_class.new(decorator) }

  let(:decorator) { DummyModel::Decorator.new(model) }
  let(:model)     { build(:dummy_model) }

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
        }.stringify_keys
      end

      it 'include the conditional attributes' do
        expect(decorator.as_json).to eq(expected_json)
      end
    end
  end
end
