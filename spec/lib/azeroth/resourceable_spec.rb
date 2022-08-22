# frozen_string_literal: true

require 'spec_helper'

fdescribe Azeroth::Resourceable do
  let(:controller_class) do
    Class.new(Controller) do
      include Azeroth::Resourceable
    end
  end

  describe '.resource_for' do
    let(:params)     { { id: document.id, format: :json } }
    let(:document)   { create(:document) }
    let(:controller) { controller_class.new(params) }

    context 'when no special option is given' do
      %i[index show new edit update destroy].each do |method_name|
        it do
          expect { controller_class.resource_for(:document) }
            .to add_method(method_name).to(controller_class)
        end
      end

      context 'when the method is called' do
        let(:rendered) { {} }

        before do
          controller_class.resource_for(:document)
          allow(controller).to receive(:render) do |args|
            rendered.merge!(args[:json])
          end
        end

        it do
          controller.show
          expect(rendered).to eq(Document::Decorator.new(document).as_json)
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
