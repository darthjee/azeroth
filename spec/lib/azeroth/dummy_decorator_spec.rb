# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::DummyDecorator do
  subject(:decorator) { Azeroth::DummyDecorator.new(object) }

  let(:model)  { build(:dummy_model) }
  let(:object) { model }

  describe '#as_json' do
    context 'when object is just a model' do
      let(:expected_json) do
        {
          favorite_game:    "pokemon",
          favorite_pokemon: "squirtle",
          first_name:       "dummy",
          id:               model.id,
          last_name:        "bot",
          age:              21
        }.stringify_keys
      end

      it 'object.as_json' do
        expect(decorator.as_json).to eq(expected_json)
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
            favorite_game:    "pokemon",
            favorite_pokemon: "squirtle",
            first_name:       "dummy",
            id:               model.id,
            last_name:        "bot",
            age:              21
          }, {
            favorite_game:    "pokemon",
            favorite_pokemon: "bulbasaur",
            first_name:       "dum",
            id:               other_model.id,
            last_name:        "bot",
            age:              65
          }
        ].map(&:stringify_keys)
      end

      it 'object.as_json' do
        expect(decorator.as_json).to eq(expected_json)
      end
    end
  end
end
