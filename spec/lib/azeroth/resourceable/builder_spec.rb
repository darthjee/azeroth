require 'spec_helper'

describe Azeroth::Resourceable::Builder do
  subject { described_class.new(klass, :document) }

  let(:klass) do
    Class.new(Controller) do
    end
  end

  describe '#build' do
    it_behaves_like 'a route resource build' do
      let(:builder) { subject }
    end
  end
end
