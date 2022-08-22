# frozen_string_literal: true

require 'spec_helper'

fdescribe Azeroth::Resourceable do
  let(:controller_class) do
    Class.new(Controller) do
      include Azeroth::Resourceable
    end
  end

  describe '.resource_for' do
    let(:params)     { { id: model.id, format: :json } }
    let(:model_name) { :document }
    let(:model)      { create(model_name) }
    let(:controller) { controller_class.new(params) }

    context 'when no special option is given' do
      %i[index show new edit update destroy].each do |method_name|
        it do
          expect { controller_class.resource_for(model_name) }
            .to add_method(method_name).to(controller_class)
        end
      end

      context 'when the method is called' do
        let(:rendered)   { {} }

        before do
          controller_class.resource_for(model_name)
          allow(controller).to receive(:render) do |args|
            rendered.merge!(args[:json])
          end
        end

        it 'decorates the model' do
          controller.show
          expect(rendered).to eq(Document::Decorator.new(model).as_json)
        end

        context 'when the model does not have a decorator' do
          let(:model_name) { :movie }

          it 'renders model as json' do
            controller.show
            expect(rendered).to eq(model.as_json)
          end
        end
      end

      context 'when passing the only option' do
        let(:options) { { only: [:index, :show] } }

        %i[index show].each do |method_name|
          it do
            expect { controller_class.resource_for(model_name, **options) }
              .to add_method(method_name).to(controller_class)
          end
        end

        %i[new edit update destroy].each do |method_name|
          it do
            expect { controller_class.resource_for(model_name, **options) }
              .not_to add_method(method_name).to(controller_class)
          end
        end
      end

      context 'when passing the except option' do
        let(:options) { { except: [:index, :show] } }

        %i[index show].each do |method_name|
          it do
            expect { controller_class.resource_for(model_name, **options) }
              .not_to add_method(method_name).to(controller_class)
          end
        end

        %i[new edit update destroy].each do |method_name|
          it do
            expect { controller_class.resource_for(model_name, **options) }
              .to add_method(method_name).to(controller_class)
          end
        end
      end
    end
  end
end
