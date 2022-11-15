# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Service::CreatorToken, type: :service do
  describe '#call' do
    context 'when values are valid' do
      it 'returns response with SMS token created' do
        user = create(:user)
        params = Controller::Request.call(user_id: user.id, kind: User::Token::KINDS[:SMS])

        response = described_class.call(params)

        expect(response.ok?).to be_truthy
        expect(response.result).to be_is_a(User::Token)
        expect(response.result.kind).to eq('sms')
      end

      it 'returns response with RESET token created' do
        user = create(:user)
        params = Controller::Request.call(user_id: user.id, kind: User::Token::KINDS[:RESET])

        response = described_class.call(params)

        expect(response.ok?).to be_truthy
        expect(response.result).to be_is_a(User::Token)
        expect(response.result.kind).to eq('reset')
      end
    end

    context 'when values are not valid' do
      it 'returns response with errors' do
        user = create(:user)
        params = Controller::Request.call(user_id: user.id)
        expected_errors = [[:code, ["can't be blank"]],
                           [:kind, ["can't be blank", 'is not included in the list']]]

        response = described_class.call(params)

        expect(response.ok?).not_to be_truthy
        expect(response.errors).to eq(expected_errors)
      end
    end

    context 'when invalid user' do
      it 'returns response with errors' do
        params = Controller::Request.call(user_id: '6782e790-6b26-4e37-8cd7-10c3b6c99452')

        response = described_class.call(params)

        expect(response.ok?).to be_falsy
        expect(response.errors).to eq(['is invalid'])
      end
    end
  end
end
