# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::Resourceable::Builder do
  subject { described_class.new(klass, :document, options) }

  let(:options)      { Azeroth::Options.new(options_hash) }
  let(:options_hash) { {} }

  let(:klass) do
    Class.new(Controller) do
    end
  end

  describe '#build' do
    it 'adds spec'
  end
end
