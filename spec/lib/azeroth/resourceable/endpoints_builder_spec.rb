# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::Resourceable::EndpointsBuilder do
  subject(:builder) { described_class.new(klass, :document, options) }

  let(:options)      { Azeroth::Options.new(options_hash) }
  let(:options_hash) { {} }

  let(:klass) do
    Class.new(Controller) do
    end
  end

  describe '#build' do
    let(:available_routes) { %i[index show new destroy create update] }
    let(:expected_params_methods)   { %i[document_id document_params] }
    let(:expected_routes_methods)   { available_routes }
    let(:expected_resource_methods) { %i[document documents] }

    context 'when no option is given' do
      it 'adds params methods' do
        expect { builder.build }
          .to(change do
            methods = klass.instance_methods
            expected_params_methods.all? { |m| methods.include?(m) }
          end)
      end

      it 'adds routes methods' do
        expect { builder.build }
          .to(change do
            methods = klass.instance_methods
            expected_routes_methods.all? { |m| methods.include?(m) }
          end)
      end

      it 'adds resource methods' do
        expect { builder.build }
          .to(change do
            methods = klass.instance_methods
            expected_resource_methods.all? { |m| methods.include?(m) }
          end)
      end
    end

    context 'when only option is given for a route' do
      let(:options_hash) { { only: route } }
      let(:route)          { available_routes.sample }
      let(:ignored_routes) { available_routes - [route] }

      it 'adds route methods' do
        expect { builder.build }
          .to(change do
            klass.instance_methods.include?(route)
          end)
      end

      it 'does not add other routes methods' do
        expect { builder.build }
          .not_to(change do
            methods = klass.instance_methods
            ignored_routes.any? { |m| methods.include?(m) }
          end)
      end
    end

    context 'when only option as array is given for a route' do
      let(:options_hash) { { only: routes } }
      let(:routes)         { [available_routes.sample, available_routes.sample].uniq }
      let(:ignored_routes) { available_routes - routes }

      it 'adds routes methods' do
        expect { builder.build }
          .to(change do
            methods = klass.instance_methods
            routes.all? { |m| methods.include?(m) }
          end)
      end

      it 'does not add other routes methods' do
        expect { builder.build }
          .not_to(change do
            methods = klass.instance_methods
            ignored_routes.any? { |m| methods.include?(m) }
          end)
      end
    end

    context 'when except option is given for a route' do
      let(:options_hash)   { { except: route } }
      let(:route)          { available_routes.sample }
      let(:added_routes)   { available_routes - [route] }

      it 'Does not add route methods' do
        expect { builder.build }
          .not_to(change do
            klass.instance_methods.include?(route)
          end)
      end

      it 'adds other routes methods' do
        expect { builder.build }
          .to(change do
            methods = klass.instance_methods
            added_routes.all? { |m| methods.include?(m) }
          end)
      end
    end

    context 'when except option as array is given for a route' do
      let(:options_hash)   { { except: routes } }
      let(:routes)         { [available_routes.sample, available_routes.sample].uniq }
      let(:added_routes)   { available_routes - routes }

      it 'Does not add routes methods' do
        expect { builder.build }
          .not_to(change do
            methods = klass.instance_methods
            routes.any? { |m| methods.include?(m) }
          end)
      end

      it 'adds other routes methods' do
        expect { builder.build }
          .to(change do
            methods = klass.instance_methods
            added_routes.all? { |m| methods.include?(m) }
          end)
      end
    end
  end
end
