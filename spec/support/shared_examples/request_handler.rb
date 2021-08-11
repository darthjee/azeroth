# frozen_string_literal: true

shared_examples 'a request handler' do |status: :ok|
  subject(:handler) do
    described_class.new(controller, model, options)
  end

  let(:controller)      { controller_class.new }
  let(:params)          { ActionController::Parameters.new(parameters) }
  let(:model)           { Azeroth::Model.new(:document, options) }
  let(:options)         { Azeroth::Options.new(options_hash) }
  let(:options_hash)    { {} }
  let(:extra_params)    { {} }

  let(:decorator)       { Document::Decorator.new(expected_resource) }
  let(:expected_json)   { decorator.as_json }
  let(:documents_count) { 0 }

  let(:controller_class) { RequestHandlerController }

  let(:format) { 'json' }

  let(:parameters) do
    { format: format }.merge(extra_params)
  end

  before do
    create_list(:document, documents_count)

    allow(controller).to receive(:params)
      .and_return(params)

    allow(controller).to receive(:render)
      .with(json: expected_json, status: status)
      .and_return(expected_json)
  end

  it 'returns all documents json' do
    expect(handler.process).to eq(expected_json)
  end

  it 'renders the json' do
    handler.process

    expect(controller).to have_received(:render)
  end

  context 'with format html' do
    let(:format) { 'html' }

    it do
      handler.process

      expect(controller).not_to have_received(:render)
    end
  end
end
