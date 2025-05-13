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
    let(:available_routes) { %i[index show new destroy create] }
    let(:expected_params_methods) { %i[document_id document_params] }
    let(:expected_routes_methods) { available_routes }
    let(:expected_resource_methods) { %i[document documents] }

    context "when no option is given" do
      it 'adds params methods' do
        expect { builder.build }
          .to change {
            methods = klass.instance_methods
            expected_params_methods.all? { |m| methods.include?(m) }
          }
      end

      it 'adds routes methods' do
        expect { builder.build }
          .to change {
            methods = klass.instance_methods
            expected_routes_methods.all? { |m| methods.include?(m) }
          }
      end

      it 'adds resource methods' do
        expect { builder.build }
          .to change {
            methods = klass.instance_methods
            expected_resource_methods.all? { |m| methods.include?(m) }
          }
      end
    end

    context "when only option is given for a route" do
      let(:options_hash) { { only: route} }
      let(:route) { available_routes.sample }
      let(:ignored_routes) { available_routes - [route] }

      it 'adds route methods' do
        expect { builder.build }
          .to change {
            klass.instance_methods.include?(route)
          }
      end

      it 'does not add other routes methods' do
        expect { builder.build }
          .not_to change {
            methods = klass.instance_methods
            ignored_routes.any? { |m| methods.include?(m) }
          }
      end
    end

    context "when only option as array is given for a route" do
      let(:options_hash) { { only: routes} }
      let(:routes) { [available_routes.sample,available_routes.sample].uniq }
      let(:ignored_routes) { available_routes - routes }

      it 'adds routes methods' do
        expect { builder.build }
          .to change {
            methods = klass.instance_methods
            routes.all? { |m| methods.include?(m) }
          }
      end

      it 'does not add other routes methods' do
        expect { builder.build }
          .not_to change {
            methods = klass.instance_methods
            ignored_routes.any? { |m| methods.include?(m) }
          }
      end
    end
  end
end
