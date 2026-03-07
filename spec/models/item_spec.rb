# frozen_string_literal: true

require 'spec_helper'

describe Item do
  describe '#visible' do
    context 'when created without specifying visible' do
      subject(:item) { create(:item) }

      it 'defaults to true' do
        expect(item.visible).to be(true)
      end
    end

    context 'when created with visible false' do
      subject(:item) { create(:item, visible: false) }

      it 'stores false' do
        expect(item.visible).to be(false)
      end
    end

    context 'when created with visible true' do
      subject(:item) { create(:item, visible: true) }

      it 'stores true' do
        expect(item.visible).to be(true)
      end
    end
  end
end
