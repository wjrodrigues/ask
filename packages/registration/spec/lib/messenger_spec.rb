# frozen_string_literal: true

RSpec.describe Lib::Messenger, type: :lib do
  describe '#publish' do
    context 'when parameters are valid' do
      it 'publishs to default client' do
        expect(Lib::Messenger::Rabbitmq).to receive(:publish)

        described_class.publish(message: 'Ask', exchange: 'notification', queue: 'mobile')
      end
    end

    context 'when parameters are invalid' do
      it 'raises queue not supported error' do
        expect(Lib::Messenger::Rabbitmq).not_to receive(:publish)

        expect do
          described_class.publish(message: 'Ask', exchange: 'notification', queue: 'sms')
        end.to raise_error(NotImplementedError, 'notification.sms unsupported')
      end

      it 'raises exchange not supported error' do
        expect(Lib::Messenger::Rabbitmq).not_to receive(:publish)

        expect do
          described_class.publish(message: 'Ask', exchange: 'notify', queue: 'mobile')
        end.to raise_error(NotImplementedError, 'notify.mobile unsupported')
      end
    end

    context 'when target are invalid' do
      it 'raises target not supported error' do
        expect(Lib::Messenger::Rabbitmq).not_to receive(:publish)

        expect do
          described_class.publish(
            message: 'Ask', exchange: 'notification', queue: 'mobile', target: :sqs
          )
        end.to raise_error(NotImplementedError, 'sqs unsupported')
      end
    end
  end
end
