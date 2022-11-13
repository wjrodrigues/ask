# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lib::ErrorTracker, type: :lib do
  describe '#notify' do
    context 'when calls' do
      it 'sends remote stack' do
        described_class.notify(nil, {})
      end
    end
  end
end
