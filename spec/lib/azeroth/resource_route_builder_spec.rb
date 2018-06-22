require 'spec_helper'

shared_examples 'a resource_reoute_builder' do |route|
  method = "#{route}_resource"

  let(:params) { {} }

  it "adds #{method} method" do
    expect { builder.build }
      .to change { klass.new.respond_to?(method) }
      .to(true)
  end

  context 'after the build' do
    let(:controller) { klass.new(params) }
    let(:document)   { Document.create }

    before { builder.build }

    context "when requesting #{method}" do
      it "returns #{method}" do
        expect(controller.send(method).as_json).to eq(expected.as_json)
      end
    end
  end
end

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
    it_behaves_like 'a resource_reoute_builder', :new do
      let(:expected) { Document.new }
    end

    it_behaves_like 'a resource_reoute_builder', :index do
      let(:expected) { Document.all }
    end

    it_behaves_like 'a resource_reoute_builder', :update do
      let(:params) { { id: document.id, document: { name: 'The Doc' } } }
      let(:expected) { document.reload }
    end

    it_behaves_like 'a resource_reoute_builder', :show do
      let(:params) { { id: document.id } }
      let(:expected) { document }
    end
  end
end
