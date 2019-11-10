# frozen_string_literal: true

describe Azeroth::Decorator do
  subject(:decorator) { DummyModel::Decorator.new(object) }

  let(:model)  { build(:dummy_model) }
  let(:object) { model }

  describe '#as_json' do
    let(:expected_json) do
      {
        name: "#{model.first_name} #{model.last_name}",
        age:  model.age,
        pokemon: model.favorite_pokemon
      }.stringify_keys
    end

    it 'returns meta data defined json' do
      expect(decorator.as_json).to eq(expected_json)
    end

    context 'when object is an array' do
      let(:object) { [model, other_model] }

      let(:other_model) do
        build(:dummy, first_name: 'dum', age: 65, favorite_pokemon: :bulbasaur)
      end

      let(:expected_json) do
        [
          {
            name: "#{model.first_name} #{model.last_name}",
            age:  model.age,
            pokemon: model.favorite_pokemon
          }, {
            name: "#{other_model.first_name} #{other_model.last_name}",
            age:  other_model.age,
            pokemon: other_model.favorite_pokemon
          }
        ].map(&:stringify_keys)
      end

      it 'returns meta data defined json' do
        expect(decorator.as_json).to eq(expected_json)
      end
    end
  end
end
