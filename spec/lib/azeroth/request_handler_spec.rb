require 'spec_helper'

fdescribe Azeroth::RequestHandler do
  describe '#process' do
    subject(:handler) { described_class.new(controller, model) }

    let(:controller) { instance_double(ActionController::Base, params: params) }
    let(:params)     { ActionController::Parameters.new }
    let(:model)      { Azeroth::Model.new(:document) }

    let(:parameters) do
    end

    context 'when action is index' do
      it do
      end
    end
  end
end
