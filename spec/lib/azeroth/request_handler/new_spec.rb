# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::RequestHandler::New do
  describe '#process' do
    it_behaves_like 'a request handler', :show do
      let(:document)          { create(:document) }
      let(:expected_resource) { Document.new }
    end
  end
end
