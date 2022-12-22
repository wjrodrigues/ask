# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lib::Cache, type: :lib do
  describe '#set' do
    context 'when to set valid value' do
      it 'sets cache with expiration' do
        allow_any_instance_of(Redis).to receive(:get).and_return(nil)

        expect_any_instance_of(Redis).to receive(:set).with('name', String, ex: 15.seconds)

        described_class.fetch('name', expires_in: 15.seconds) { 'Ask' }
      end

      it 'sets cache without expiration' do
        allow_any_instance_of(Redis).to receive(:get).and_return(nil)

        expect_any_instance_of(Redis).to receive(:set).with('name', String, ex: nil)

        described_class.fetch('name') { -> { 'Ask' }.call }
      end

      it 'returns cached value' do
        allow_any_instance_of(Redis).to receive(:get).and_return(Marshal.dump('Ask'))

        expect_any_instance_of(Redis).not_to receive(:set)

        described_class.fetch('name', expires_in: 15.seconds) { 'Ask' }
      end
    end

    context 'when to set invalid value' do
      it 'raises error if value is not supported' do
        allow_any_instance_of(Redis).to receive(:get).and_return(nil)

        expect do
          described_class.fetch('name', expires_in: 15.seconds) { Struct.new(:name).new }
        end.to raise_error(NoMatchingPatternError)
      end
    end
  end
end
