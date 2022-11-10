# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lib::Tracker, type: :lib do
  describe '#tracking' do
    context 'when calls' do
      it 'sends remote stack' do
        described_class.tracking(stack: nil)
      end
    end
  end
end
