# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lib::Messenger::Rabbitmq, type: :lib do
  describe '#publish' do
    context 'when called' do
      it 'create only instance' do
        double_bunny = double(start: double(connected?: true))

        expect(Bunny).to receive(:new).once.and_return(double_bunny)

        2.times { described_class.publish }
      end
    end
  end
end
