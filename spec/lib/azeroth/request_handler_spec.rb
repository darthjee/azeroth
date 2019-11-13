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
    let(:documents_count) { 0 }
    let(:extra_params)    { {} }

    let(:controller_class) do
      Class.new(ActionController::Base) do
        include Azeroth::Resourceable

        resource_for :document
      end
    end

    let(:parameters) do
      { format: format, action: action }.merge(extra_params)
    end

    before do
      documents_count.times { create(:document) }

      allow(controller).to receive(:params)
        .and_return(params)

      allow(controller).to receive(:render)
        .with(json: expected_json)
        .and_return(expected_json)
    end

    context 'when action is index' do
      let(:action)            { 'index' }
      let(:expected_resource) { Document.all }
      let(:documents_count)   { 3 }

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

    context 'when action is show' do
      let(:extra_params)      { { 'id' => document.id } }
      let(:action)            { 'show' }
      let(:expected_resource) { document }
      let!(:document)         { create(:document) }

      context 'with format json' do
        let(:format) { 'json' }

        it 'returns document json' do
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

    context 'when action is update' do
      let(:action)            { 'update' }
      let(:expected_resource) { document }
      let!(:document)         { create(:document) }

      let(:extra_params) do
        {
          id: document.id,
          document: {
            name: 'New Name'
          }
        }
      end

      context 'with format json' do
        let(:format) { 'json' }

        it 'returns document json' do
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

    context 'when action is not allowed' do
      let(:action)        { 'invalid' }
      let(:expected_json) { '' }

      context 'with format json' do
        let(:format) { 'json' }

        it do
          expect { handler.process }
            .to raise_error(Azeroth::Exception::NotAllowedAction)
        end
      end

      context 'with format html' do
        let(:format) { 'html' }

        it do
          expect { handler.process }
            .to raise_error(Azeroth::Exception::NotAllowedAction)
        end
      end
    end
  end
end
