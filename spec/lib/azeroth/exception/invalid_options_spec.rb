# frozen_string_literal: true

require 'spec_helper'

describe Azeroth::Exception::InvalidOptions do
  let(:exception) { described_class.new(%i[invalid option]) }

  describe 'messagee' do
    let(:expected_message) do
      'Invalid keys on options initialization (invalid option)'
    end

    it 'returns message with invalid keys' do
      expect(exception.message)
        .to eq(expected_message)
    end
  end
end
