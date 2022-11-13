# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Controller::Request, type: :controller do
  describe '#call' do
    context 'when parameters are informed' do
      it 'returns OpenStruct instance with parameters' do
        response = described_class.call({ name: 'ruby', version: 3 })

        expect(response).to be_is_a(Struct)
        expect(response.name).to eq('ruby')
        expect(response.version).to eq(3)
      end
    end

    context 'when parameters are not informed' do
      it 'returns nil' do
        response = described_class.call({})

        expect(response).to be_nil
      end
    end
  end
end
