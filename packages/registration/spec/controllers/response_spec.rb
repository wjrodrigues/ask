# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Controller::Response, type: :controller do
  describe '#call' do
    context 'when the status is valid' do
      it 'returns array with http status and body' do
        response = described_class.call(:CREATED, { name: 'ruby' })

        expected_response = [201, { name: 'ruby' }]

        expect(response).to eq(expected_response)
      end

      it 'returns array with http status and empty body' do
        response = described_class.call(:CREATED)

        expected_response = [201, nil]

        expect(response).to eq(expected_response)
      end
    end
  end
end
