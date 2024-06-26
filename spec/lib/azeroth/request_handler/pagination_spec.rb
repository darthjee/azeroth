# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::RequestHandler::Pagination do
  subject(:pagination) { described_class.new(params, options) }

  let(:options)      { Azeroth::Options.new(options_hash) }
  let(:options_hash) { {} }
  let(:params)       { ActionController::Parameters.new(parameters) }
  let(:parameters)   { {} }

  describe '#offset' do
    context 'when nothing was defined' do
      it do
        expect(pagination.offset).to be_zero
      end
    end

    context 'when parameters has page value' do
      let(:parameters)        { { page: page } }
      let(:page)              { Random.rand(1..10) }
      let(:expected_offset)   { (page - 1) * expected_per_page }
      let(:expected_per_page) { 20 }

      it 'returns value from request using default per_page' do
        expect(pagination.offset).to eq(expected_offset)
      end
    end

    context 'when parameters has per_page value' do
      let(:parameters)        { { per_page: per_page } }
      let(:per_page)          { Random.rand(1..10) }

      it do
        expect(pagination.offset).to be_zero
      end
    end

    context 'when parameters has page and per page values' do
      let(:parameters)        { { page: page, per_page: per_page } }
      let(:page)              { Random.rand(1..10) }
      let(:per_page)          { Random.rand(1..10) }
      let(:expected_offset)   { (page - 1) * expected_per_page }
      let(:expected_per_page) { per_page }

      it 'returns value from request' do
        expect(pagination.offset).to eq(expected_offset)
      end
    end

    context 'when parameters has page and options per page values' do
      let(:parameters)        { { page: page } }
      let(:options_hash)      { { per_page: per_page } }
      let(:page)              { Random.rand(1..10) }
      let(:per_page)          { Random.rand(1..10) }
      let(:expected_offset)   { (page - 1) * expected_per_page }
      let(:expected_per_page) { per_page }

      it 'returns value from request and options' do
        expect(pagination.offset).to eq(expected_offset)
      end
    end

    context 'when params has page and per_page and options per page values' do
      let(:parameters)        { { page: page, per_page: per_page } }
      let(:options_hash)      { { per_page: options_per_page } }
      let(:page)              { Random.rand(1..10) }
      let(:options_per_page)  { Random.rand(1..10) }
      let(:per_page)          { Random.rand(1..10) }
      let(:expected_offset)   { (page - 1) * expected_per_page }
      let(:expected_per_page) { per_page }

      it 'returns value from request' do
        expect(pagination.offset).to eq(expected_offset)
      end
    end
  end

  describe '#limit' do
    context 'when nothing was defined' do
      it 'returns default value' do
        expect(pagination.limit).to eq(20)
      end
    end

    context 'when parameters has per_page' do
      let(:parameters) { { per_page: per_page } }
      let(:per_page)   { Random.rand(1..10) }

      it 'returns value from request' do
        expect(pagination.limit).to eq(per_page)
      end
    end

    context 'when options has per_page' do
      let(:options_hash) { { per_page: per_page } }
      let(:per_page)     { Random.rand(1..10) }

      it 'returns value from options' do
        expect(pagination.limit).to eq(per_page)
      end
    end

    context 'when params and options have per_page' do
      let(:parameters)       { { per_page: per_page } }
      let(:per_page)         { Random.rand(1..10) }
      let(:options_hash)     { { per_page: options_per_page } }
      let(:options_per_page) { Random.rand(1..10) }

      it 'returns value from request' do
        expect(pagination.limit).to eq(per_page)
      end
    end
  end

  describe '#current_page' do
    context 'when nothing was defined' do
      it 'returns first page' do
        expect(pagination.current_page).to eq(1)
      end
    end

    context 'when parameters has page' do
      let(:parameters) { { page: page } }
      let(:page)       { Random.rand(1..10) }

      it 'returns value from request' do
        expect(pagination.current_page).to eq(page)
      end
    end
  end
end
