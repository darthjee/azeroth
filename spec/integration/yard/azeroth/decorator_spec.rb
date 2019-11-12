# frozen_string_literal: true

describe Azeroth::Decorator do
  subject(:decorator) { DummyModel::Decorator.new(object) }

  let(:object) do
    DummyModel.new(
      id: 100,
      first_name: 'John',
      last_name: 'Wick',
      favorite_pokemon: 'Arcanine'
    )
  end

  describe '#as_json' do
    it 'returns exposed attributes' do
      expect(decorator.as_json).to eq(
        'name' => 'John Wick',
        'age' => nil,
        'pokemon' => 'Arcanine'
      )
    end
  end
end
