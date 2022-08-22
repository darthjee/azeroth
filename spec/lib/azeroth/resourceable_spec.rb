# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::Resourceable do
  let(:controller_class) do
    Class.new(Controller) do
      include Azeroth::Resourceable
    end
  end

  describe '.resource_for' do
    let(:options) { {} }

    context 'when no special option is given' do
      it do
        expect { controller_class.resource_for(:document) }
          .to add_method(:index).to(controller_class)
      end
    end
  end
end
