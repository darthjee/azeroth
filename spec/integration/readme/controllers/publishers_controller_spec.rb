# frozen_string_literal: true

require 'spec_helper'

describe PublishersController, controller: true do
  describe 'POST create' do
    it 'create publisher' do
      post "/publishers.json", params: {
        publisher: {
          name: 'Nintendo'
        }
      }

      publisher = Publisher.last

      expect(response.body).to eq({
        id: publisher.id,
        name: 'Nintendo',
      }.to_json)
    end
  end
end
