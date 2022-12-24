# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lib::Request, type: :lib do
  describe '#execute' do
    context 'when request any URL' do
      it 'returns RestClient::Response instance' do
        VCR.use_cassette('request/get') do
          response = described_class.execute('https://dummyjson.com/products', method: :get)

          expect(response).to be_a(RestClient::Response)
        end
      end

      it 'raises ClientRequest error' do
        expect { described_class.execute('') }.to raise_error(StandardError)
      end

      it 'raises request error' do
        VCR.use_cassette('request/get_error') do
          expect do
            described_class.execute('https://dummyjson.com/product', method: :get)
          end.to raise_error(Lib::HttpError)
        end
      end
    end
  end
end
