# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::Decorator::MethodBuilder do
  let(:decorator_class) { Class.new(Azeroth::Decorator) }
  let(:decorator)       { decorator_class.new(object) }
  let(:model)           { build(:dummy_model) }
  let(:object)          { model }
  let(:options)         { Azeroth::Decorator::Options.new(options_hash) }
  let(:options_hash)    { {} }

  describe '.build_reader' do
    it do
      expect { described_class.build_reader(decorator_class, :age, options) }
        .to add_method(:age).to(decorator)
    end

    it do
      described_class.build_reader(decorator_class, :age, options)

      expect(decorator.age).to eq(model.age)
    end

    context "when passing reader option" do
      context "when passing true" do
        let(:options_hash) { { reader: true } }

        it do
          expect { described_class.build_reader(decorator_class, :age, options) }
            .to add_method(:age).to(decorator)
        end
      end

      context "when passing false" do
        let(:options_hash) { { reader: false } }

        it do
          expect { described_class.build_reader(decorator_class, :age, options) }
            .not_to add_method(:age).to(decorator)
        end
      end
    end

    context "when method already existed" do
      before do
        decorator_class.define_method(:age) { 1 }
      end

      context "when passing override option as true" do
        let(:options_hash) { { override: true } }

        it do
          expect { described_class.build_reader(decorator_class, :age, options) }
            .to change_method(:age).on(decorator)
        end
      end

      context "when passing override option as true" do
        let(:options_hash) { { override: false } }

        it do
          expect { described_class.build_reader(decorator_class, :age, options) }
            .not_to change_method(:age).on(decorator)
        end
      end
    end
  end
end
