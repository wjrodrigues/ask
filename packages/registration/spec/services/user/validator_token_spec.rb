# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Service::ValidatorToken, type: :service do
  describe '#call' do
    context 'when token exists' do
      it 'returns response with true value' do
        user_token = create(:user_token, :sms)
        params = Controller::Request.call(
          user_id: user_token.user_id,
          kind: User::Token::KINDS[:SMS]
        )

        response = described_class.call(params)

        expect(response.ok?).to be_truthy
      end

      context 'and used token' do
        it 'returns response with error message' do
          user_token = create(:user_token, :sms, used_at: DateTime.current)
          params = Controller::Request.call(
            user_id: user_token.user_id,
            kind: User::Token::KINDS[:SMS]
          )

          response = described_class.call(params)

          expect(response.errors).to eq(['Token has already been used'])
          expect(response).not_to be_ok
        end
      end

      context 'and expired token' do
        it 'returns response with error message' do
          user_token = create(:user_token, :sms, expire_at: 1.day.ago)
          params = Controller::Request.call(
            user_id: user_token.user_id,
            kind: User::Token::KINDS[:SMS]
          )

          response = described_class.call(params)

          expect(response.errors).to eq(['Token expired'])
          expect(response).not_to be_ok
        end
      end
    end
  end
end
