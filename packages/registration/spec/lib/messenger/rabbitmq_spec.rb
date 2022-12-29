# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lib::Messenger::Rabbitmq, type: :lib do
  describe '#publish' do
    # rubocop:disable Style/ClassVars
    before(:each) { Lib::Messenger::Rabbitmq.class_variable_set :@@session, nil }
    # rubocop:enable Style/ClassVars

    context 'when message is published' do
      it 'closes the channel' do
        spy_channel = spy(basic_publish: true, close: true)
        double_bunny = double(start: double(connected?: true, create_channel: spy_channel))

        allow(Bunny).to receive(:new).and_return(double_bunny)

        described_class.publish(message: 'Ask message', exchange: 'notification', queue: 'mobile')

        expect(spy_channel).to have_received(:close).once
      end

      it 'creates only one client instance' do
        double_channel = double(basic_publish: true, close: true)
        double_bunny = double(start: double(connected?: true, create_channel: double_channel))

        expect(Bunny).to receive(:new).and_return(double_bunny).once

        2.times do
          described_class.publish(
            message: 'Ask message', exchange: 'notification', queue: 'mobile'
          )
        end
      end
    end

    context 'when publishing error occurs' do
      it 'calls ErrorTracker#notify' do
        allow(Bunny).to receive(:new).and_return(StandardError)

        expect(Lib::ErrorTracker).to receive(:notify)

        RSpec::Mocks.with_temporary_scope do
          described_class.publish(
            message: 'Ask message', exchange: 'notification', queue: 'mobile'
          )
        end
      end
    end
  end
end
