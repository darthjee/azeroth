# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::Decorator::MethodBuilder do
  let(:decorator_class) { Class.new(Azeroth::Decorator) }
  let(:decorator)       { decorator_class.new(object) }
  let(:model)           { build(:dummy_model) }
  let(:object)          { model }
  let(:options)         { Azeroth::Decorator::Options.new({}) } 

  describe '.build_reader' do
    it do
      expect { described_class.build_reader(decorator_class, :age, options) }
        .to add_method(:age).to(decorator)
    end

    it do
      described_class.build_reader(decorator_class, :age, options)

      expect(decorator.age).to eq(model.age)
    end
  end
end
