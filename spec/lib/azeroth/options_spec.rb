# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::Options do
  subject(:options) { described_class.new }

  describe "#actions" do
    it 'returns default actions' do
      expect(options.actions)
        .to eq(%i[create destroy edit index new show update])
    end

    context 'when passing only options' do
      subject(:options) { described_class.new(only: [:index]) }

      it 'returns defined actions' do
        expect(options.actions)
          .to eq(%i[index])
      end

      context 'when not passing an array' do
        subject(:options) { described_class.new(only: :index) }

        it 'returns defined actions as array' do
          expect(options.actions)
            .to eq(%i[index])
        end
      end
    end

    context 'when passing except options' do
      subject(:options) do
        described_class.new(except: [:index, :create])
      end

      it 'returns not excluded actions' do
        expect(options.actions)
          .to eq(%i[destroy edit new show update])
      end

      context 'when not passing an array' do
        subject(:options) { described_class.new(except: :index) }

        it 'returns not excluded actions' do
          expect(options.actions)
            .to eq(%i[create destroy edit new show update])
        end
      end
    end
  end
end
