# frozen_string_literal: true

require 'spec_helper'

fdescribe Azeroth::Resourceable do
  let(:controller_class) do
    Class.new(Controller) do
      include Azeroth::Resourceable
    end
  end

  describe '.resource_for' do
    context 'when no special option is given' do
      %i[index show new edit update destroy].each do |method_name|
        it do
          expect { controller_class.resource_for(:document) }
            .to add_method(method_name).to(controller_class)
        end
      end

      context 'when passing the only option' do
        let(:options) { { only: [:index, :show] } }

        %i[index show].each do |method_name|
          it do
            expect { controller_class.resource_for(:document, **options) }
              .to add_method(method_name).to(controller_class)
          end
        end

        %i[new edit update destroy].each do |method_name|
          it do
            expect { controller_class.resource_for(:document, **options) }
              .not_to add_method(method_name).to(controller_class)
          end
        end
      end
    end
  end
end
