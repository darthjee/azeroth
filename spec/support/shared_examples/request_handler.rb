# frozen_string_literal: true

shared_examples 'a request handler' do |action|
  subject(:handler) { described_class.new(controller, model) }

  let(:controller)      { controller_class.new }
  let(:params)          { ActionController::Parameters.new(parameters) }
  let(:model)           { Azeroth::Model.new(:document) }
  let(:extra_params)    { {} }

  let(:decorator)       { Document::Decorator.new(expected_resource) }
  let(:expected_json)   { decorator.as_json }
  let(:documents_count) { 3 }

  let(:controller_class) { RequestHandlerController }

  let(:format) { 'json' }

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
