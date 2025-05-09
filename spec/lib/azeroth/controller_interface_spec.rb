# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::ControllerInterface do
  subject(:interface)    { described_class.new(controller) }

  let(:controller)       { controller_class.new }
  let(:controller_class) { RequestHandlerController }

  describe '#add_headers' do
    let(:controller_headers) do
      {
        old_key: 100
      }
    end

    let(:headers) do
      {
        key1: 10,
        key2: 20
      }
    end

    before do
      allow(controller)
        .to receive(:headers)
        .and_return(controller_headers)
    end

    it 'sets controller headers' do
      expect { interface.add_headers(headers) }
        .to change { controller_headers }
        .from(controller_headers)
        .to(controller_headers.merge(headers.stringify_keys))
    end
  end

  describe '#render_json' do
    let(:json)   { { key: 'value' } }
    let(:status) { 200 }

    before do
      allow(controller)
        .to receive(:render)
        .with(json: json, status: status)
    end

    it 'renders json' do
      interface.render_json(json, status)

      expect(controller).to have_received(:render)
    end
  end

  describe '#set' do
    it 'sets instance variable' do
      expect { interface.set(:name, 20) }
        .to change { controller.instance_variable_get('@name') }
        .from(nil)
        .to(20)
    end
  end

  describe 'method missing' do
    before do
      create(:document)
    end

    it 'delegates call to controller' do
      expect(interface.documents)
        .to eq(Document.all)
    end

    context 'when method is not defined' do
      it do
        expect { interface.pokemons }
          .to raise_error(NoMethodError)
      end
    end
  end
end
