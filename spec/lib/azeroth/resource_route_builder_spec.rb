require 'spec_helper'

describe Azeroth::ResourceRouteBuilder do
  subject { described_class.new(model, builder) }

  let(:model)   { Azeroth::Model.new(:document) }
  let(:builder) { Sinclair.new(klass) }
  let(:klass)   { Class.new(ResourceRouteBuilderController) }

  before do
    subject.append
    10.times { Document.create }
  end

  describe '#append' do
    it_behaves_like 'a route resource build'
  end
end
