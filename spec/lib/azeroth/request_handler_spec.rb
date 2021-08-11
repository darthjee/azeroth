# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::RequestHandler do
  describe '#process' do
    subject(:handler) do
      handler_class.new(controller, model, options)
    end

    let(:controller) { controller_class.new }
    let(:params)     { ActionController::Parameters.new(parameters) }
    let(:model)      { Azeroth::Model.new(:document, options) }
    let(:options)    { Azeroth::Options.new }

    let(:decorator)       { Document::Decorator.new(Document.all) }
    let(:expected_json)   { decorator.as_json }
    let(:documents_count) { 3 }

    let(:controller_class) { RequestHandlerController }

    let(:parameters) do
      { format: format }
    end

    let(:handler_class) do
      Class.new(described_class) do
        private

        def resource
          Document.all
        end
      end
    end

    before do
      create_list(:document, documents_count)

      allow(controller).to receive(:params)
        .and_return(params)

      allow(controller).to receive(:render)
        .with(json: expected_json, status: :ok)
        .and_return(expected_json)
    end

    context 'with format json' do
      let(:format) { 'json' }

      it 'returns json for resource' do
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
