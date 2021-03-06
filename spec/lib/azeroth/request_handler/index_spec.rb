# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::RequestHandler::Index do
  describe '#process' do
    it_behaves_like 'a request handler' do
      let(:documents_count)   { 3 }
      let(:expected_resource) { Document.all }
    end
  end
end
