# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::ResourceRouteBuilder do
  subject(:resource_routes_builder) do
    described_class.new(model, builder)
  end

  let(:model)   { Azeroth::Model.new(:document) }
  let(:builder) { Sinclair.new(klass) }
  let(:klass)   { Class.new(ResourceRouteBuilderController) }

  before do
    resource_routes_builder.append
    10.times { Document.create }
  end

  describe '#append' do
    it_behaves_like 'a route resource build'
  end
end
