# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lib::Request, type: :lib do
  describe '#options' do
    context 'when request set options' do
      it 'sets the timeout to 30 seconds' do
        expect(::HTTP).to receive(:timeout).with(30).and_return(double(get: ->(v) {}))

        described_class.get('http://localhost')
      end
    end
  end

  describe '#get' do
    context 'when request any URL' do
      it 'returns HTTP::Response instance' do
        VCR.use_cassette('request/get') do
          response = described_class.get('http://localhost:8001')

          expect(response).to be_a(HTTP::Response)
        end
      end

      it 'raises error if URL is invalid' do
        expect { described_class.get('https://localhost:8001') }.to raise_error(StandardError)
      end
    end
  end

  describe '#post' do
    context 'when request any URL' do
      it 'returns HTTP::Response instance' do
        VCR.use_cassette('request/post') do
          response = described_class.post('http://localhost:8001')

          expect(response).to be_a(HTTP::Response)
        end
      end

      it 'raises error if URL is invalid' do
        expect { described_class.post('https://localhost:8001') }.to raise_error(StandardError)
      end
    end
  end
end
