# frozen_string_literal: true

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

      context 'when object is an active record relation' do
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
    end
  end
end
