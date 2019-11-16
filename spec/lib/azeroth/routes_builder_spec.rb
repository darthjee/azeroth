# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::RoutesBuilder do
  subject(:routes_builder) do
    described_class.new(model, builder, options)
  end

  let(:controller) { controller_class.new }
  let(:params)     { ActionController::Parameters.new(parameters) }
  let(:model)      { Azeroth::Model.new(:document) }
  let(:builder)    { Sinclair.new(controller_class) }
  let(:parameters) { { action: :index, format: :json } }

  let(:options)      { Azeroth::Options.new(options_hash) }
  let(:options_hash) { {} }

  let(:expected_json) do
    Document::Decorator.new(Document.all).as_json
  end

  let(:controller_class) do
    Class.new(ActionController::Base) do
      include Azeroth::Resourceable

      def documents
        Document.all
      end
    end
  end

  before do
    10.times { Document.create }

    allow(controller).to receive(:params)
      .and_return(params)

    allow(controller).to receive(:render)
      .with(json: expected_json)
      .and_return(expected_json)
  end

  describe '#append' do
    before { routes_builder.append }

    it 'adds index route' do
      expect do
        builder.build
      end.to add_method(:index).to(controller)
    end

    describe 'when calling index' do
      before { builder.build }

      it 'returns the index object' do
        expect(controller.index).to eq(expected_json)
      end

      it 'renders the json' do
        controller.index

        expect(controller).to have_received(:render)
          .with(json: expected_json)
      end
    end
  end
end
