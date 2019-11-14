# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::RequestHandler do
  describe '#process' do
    subject(:handler) { described_class.new(controller, model) }

    let(:controller) { controller_class.new }
    let(:params)     { ActionController::Parameters.new(parameters) }
    let(:model)      { Azeroth::Model.new(:document) }

    let(:decorator)       { Document::Decorator.new(expected_resource) }
    let(:expected_json)   { decorator.as_json }
    let(:documents_count) { 3 }

    let(:expected_resource) { Document.all }

    let(:controller_class) { RequestHandlerController }

    let(:parameters) do
      { format: format, action: 'index' }
    end

    before do
      documents_count.times { create(:document) }

      allow(controller).to receive(:params)
        .and_return(params)

      allow(controller).to receive(:render)
        .with(json: expected_json)
        .and_return(expected_json)
    end

    context 'with format json' do
      let(:format) { 'json' }

      it 'returns all documents json' do
        expect(handler.process).to eq(expected_json)
      end

      it 'renders the json' do
        handler.process

        expect(controller).to have_received(:render)
      end
    end

    context 'with format html' do
      let(:format) { 'html' }

      it do
        handler.process

        expect(controller).not_to have_received(:render)
      end
    end
  end
end
