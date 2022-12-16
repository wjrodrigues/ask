# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Controller::Response, type: :controller do
  describe '#call' do
    context 'when calls success' do
      it 'returns array with http status and body' do
        response = described_class.success(status: :CREATED, body: { name: 'ruby' }).call(true)

        expected_response = [201, { name: 'ruby' }]

        expect(response).to eq(expected_response)
      end

      it 'returns array with http status and empty body' do
        response = described_class.success(status: :CREATED).call(true)

        expected_response = [201, nil]

        expect(response).to eq(expected_response)
      end

      it 'calls action passed by parameter' do
        action = spy

        described_class.success(status: :CREATED, action:).call(true)

        expect(action).to have_received(:call)
      end
    end

    context 'when calls failure' do
      it 'returns array with http status and body' do
        response = described_class.failure(status: :NOT_FOUND, body: { name: 'ruby' }).call(false)

        expected_response = [404, { name: 'ruby' }]

        expect(response).to eq(expected_response)
      end

      it 'returns array with http status and empty body' do
        response = described_class.failure(status: :NOT_FOUND).call(false)

        expected_response = [404, nil]

        expect(response).to eq(expected_response)
      end

      it 'calls action passed by parameter' do
        action = spy

        described_class.success(status: :NOT_FOUND, action:).call(false)

        expect(action).to have_received(:call)
      end
    end
  end
end
