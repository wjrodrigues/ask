# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Controller::Base, type: :controller do
  describe '#body' do
    context 'when request is application/json' do
      it 'returns body in hash' do
        body = double(read: { name: 'ruby' }.to_json)
        request = double(env: { 'CONTENT_TYPE' => 'application/json' }, body:)

        response = described_class.body(request)

        expect(response).to eq({ 'name' => 'ruby' })
        expect(response).to be_a(Hash)
      end
    end

    context 'when request is any' do
      it 'returns raw body' do
        body = double(read: 'ruby 3.0')
        request = double(env: { 'CONTENT_TYPE' => nil }, body:)

        response = described_class.body(request)

        expect(response).to eq('ruby 3.0')
        expect(response).to be_a(String)
      end
    end
  end
end
