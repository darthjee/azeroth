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
    let(:expected_params_methods) { %i[document_id document_params] }
    let(:expected_routes_methods) { %i[index show new destroy create] }
    let(:expected_resource_methods) { %i[document documents] }

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
end
