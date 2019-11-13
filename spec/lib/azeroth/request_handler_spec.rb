# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::RequestHandler do
  describe '#process' do
    subject(:handler) { described_class.new(controller, model) }

    let(:controller) { instance_double(ActionController::Base, params: params) }
    let(:params)     { ActionController::Parameters.new(parameters) }
    let(:model)      { Azeroth::Model.new(:document) }

    let(:expected_json)   {}
    let(:documents_count) { 0 }
    let(:extra_params)    { {} }

    let(:parameters) do
      { format: format, action: action }.merge(extra_params)
    end

    before do
      documents_count.times { create(:document) }
      allow(controller).to receive(:render)
        .with(json: expected_json)
        .and_return(expected_json)
    end

    context 'when action is index' do
      let(:action)          { 'index' }
      let(:expected_json)   { Document.all.to_json }
      let(:documents_count) { 3 }

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
    end

    context 'when action is show' do
      let(:extra_params)    { { 'id' => document.id } }
      let(:action)          { 'show' }
      let(:expected_json)   { document.to_json }
      let!(:document)       { create(:document) }

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
    end
  end
end