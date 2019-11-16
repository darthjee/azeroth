# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::RequestHandler::Edit do
  describe '#process' do
    it_behaves_like 'a request handler' do
      let!(:document)         { create(:document) }
      let(:expected_resource) { document }
      let(:extra_params)      { { 'id' => document.id } }
    end
  end
end
