# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::Resourceable::ResourcesBuilder do
  subject(:builder) { described_class.new(klass, :document, options) }

  let(:options)      { Azeroth::Options.new(options_hash) }
  let(:options_hash) { {} }

  let(:klass) do
    Class.new(Controller) do
    end
  end

  describe '#build' do
    let(:expected_resource_methods) { %i[document documents] }

    it 'adds resource methods' do
      expect { builder.build }
        .to change { (klass.instance_methods & expected_resource_methods).sort }
        .from([]).to(expected_resource_methods.sort)
    end
  end
end
