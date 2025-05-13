# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::Resourceable do
  let(:controller_class) do
    Class.new(Controller) do
      include Azeroth::Resourceable
    end
  end

  describe '.resource_for' do
    let(:available_routes) { %i[index show new destroy create update] }
    let(:params)           { { id: model.id, format: :json } }
    let(:model_name)       { :document }
    let(:model)            { create(model_name) }
    let(:controller)       { controller_class.new(params) }
    let(:decorator)        { Document::Decorator }

    context 'when no special option is given' do
      it 'add routes methods' do
        expect { controller_class.resource_for(model_name) }
          .to change { (controller.methods & available_routes).sort }
          .from([]).to(available_routes.sort)
      end
    end

    context 'when passing the only option' do
      let(:options) { { only: expected_routes_methods } }
      let(:expected_routes_methods) { %i[index show] }

      it 'add routes methods' do
        expect { controller_class.resource_for(model_name, **options) }
          .to change { (controller.methods & available_routes).sort }
          .from([]).to(expected_routes_methods.sort)
      end
    end

    context 'when passing the except option' do
      let(:options) { { except: skipped_routes } }
      let(:skipped_routes)          { %i[index show] }
      let(:expected_routes_methods) { available_routes - skipped_routes }

      it 'add routes methods' do
        expect { controller_class.resource_for(model_name, **options) }
          .to change { (controller.methods & available_routes).sort }
          .from([]).to(expected_routes_methods.sort)
      end
    end

    context 'when passing decorator option' do
      let(:model_name) { :movie }
      let(:decorator)  { Movie::SimpleDecorator }
      let(:rendered)   { {} }

      before do
        controller_class.resource_for(model_name, decorator: decorator)

        allow(controller).to receive(:render) do |args|
          rendered.merge!(args[:json])
        end
      end

      it 'decorates the model' do
        controller.show
        expect(rendered).to eq(decorator.new(model).as_json)
      end
    end

    context 'when the method is called' do
      let(:rendered) { {} }

      before do
        controller_class.resource_for(model_name)
        allow(controller).to receive(:render) do |args|
          rendered.merge!(args[:json])
        end
      end

      it 'decorates the model' do
        controller.show
        expect(rendered).to eq(decorator.new(model).as_json)
      end

      context 'when the model does not have a decorator' do
        let(:model_name) { :movie }

        it 'renders model as json' do
          controller.show
          expect(rendered).to eq(model.as_json)
        end
      end
    end
  end

  describe '.model_for' do
    let(:model_name) { :document }
    let(:model)                     { create(model_name) }
    let(:controller)                { controller_class.new({}) }
    let(:expected_resource_methods) { %i[document documents] }

    it 'adds resource methods' do
      expect { controller_class.model_for(model_name) }
        .to change { (controller.methods & expected_resource_methods).sort }
        .from([]).to(expected_resource_methods.sort)
    end
  end
end
