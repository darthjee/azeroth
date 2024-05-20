# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::Decorator::MethodBuilder do
  subject(:build_reader) do
    described_class.build_reader(decorator_class, :age, options)
  end

  let(:decorator_class) { Class.new(Azeroth::Decorator) }
  let(:decorator)       { decorator_class.new(object) }
  let(:model)           { build(:dummy_model) }
  let(:object)          { model }
  let(:options)         { Azeroth::Decorator::Options.new(options_hash) }
  let(:options_hash)    { {} }

  describe '.build_reader' do
    it do
      expect { build_reader }
        .to add_method(:age).to(decorator)
    end

    it do
      build_reader

      expect(decorator.age).to eq(model.age)
    end

    context 'when passing reader option' do
      context 'when passing true' do
        let(:options_hash) { { reader: true } }

        it do
          expect { build_reader }
            .to add_method(:age).to(decorator)
        end
      end

      context 'when passing false' do
        let(:options_hash) { { reader: false } }

        it do
          expect { build_reader }
            .not_to add_method(:age).to(decorator)
        end
      end
    end

    context 'when passing override option as true' do
      let(:options_hash) { { override: false } }

      it do
        expect { build_reader }
          .to add_method(:age).to(decorator)
      end
    end

    context 'when method already existed' do
      before do
        decorator_class.define_method(:age) { 1 }
      end

      context 'when passing override option as true' do
        let(:options_hash) { { override: true } }

        it do
          expect { build_reader }
            .to change_method(:age).on(decorator)
        end
      end

      context 'when passing override option as false' do
        let(:options_hash) { { override: false } }

        it do
          expect { build_reader }
            .not_to change_method(:age).on(decorator)
        end
      end
    end
  end
end
