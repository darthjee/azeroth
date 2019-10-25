require 'spec_helper'

describe DocumentsController do
  let(:parsed_response) do
    JSON.parse(response.body)
  end

  describe 'GET index' do
    before { get :index }

    it { expect(response).to be_successful }

    it { expect(parsed_response).to eq([]) }

    context "when there is a document" do
      before { Document.create }

      it { expect(response).to be_successful }

      it { expect(parsed_response).to eq([]) }
    end
  end
end
