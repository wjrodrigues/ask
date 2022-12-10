# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::Token::Repository, type: :repository do
  describe '#valid?' do
    context 'when to check if token exists' do
      it 'returns true if exists' do
        user_token = create(:user_token)

        response = described_class.valid?(user_id: user_token.user_id, kind: user_token.kind,
                                          code: user_token.code)

        expect(response).to be_truthy
      end

      it "returns false if it doesn't exist" do
        user_token = build(:user_token)

        response = described_class.valid?(user_id: user_token.user_id, kind: user_token.kind,
                                          code: user_token.code)

        expect(response).to be_falsy
      end
    end
  end

  describe '#find' do
    context 'when token is requested' do
      it 'returns record if exists' do
        user_token = create(:user_token)

        response = described_class.find(user_id: user_token.user_id, kind: user_token.kind,
                                        code: user_token.code)

        expect(response).to eq(user_token)
      end

      it 'returns nil if record does not exist' do
        user_token = build(:user_token)

        response = described_class.find(user_id: user_token.user_id, kind: user_token.kind,
                                        code: user_token.code)

        expect(response).to be_nil
      end
    end
  end

  describe '#expired?' do
    context 'when it is checked if the token has expired' do
      it 'returns false if expired' do
        user_token = create(:user_token)

        response = described_class.expired?(user_id: user_token.user_id, kind: user_token.kind,
                                            code: user_token.code)

        expect(response).to be_falsy
      end

      it 'returns true if expired' do
        user_token = create(:user_token, :expired)

        response = described_class.expired?(user_id: user_token.user_id, kind: user_token.kind,
                                            code: user_token.code)

        expect(response).to be_truthy
      end

      it 'returns true if token does not exist' do
        user_token = build(:user_token, :expired)

        response = described_class.expired?(user_id: user_token.user_id, kind: user_token.kind,
                                            code: user_token.code)

        expect(response).to be_truthy
      end
    end
  end

  describe '#burn!' do
    context 'when token valid' do
      it 'marks token as used' do
        user_token = create(:user_token)

        described_class.burn!(user_id: user_token.user_id, kind: user_token.kind,
                              code: user_token.code)

        expect(user_token.reload).to be_used
      end
    end

    context 'when token invalid' do
      it 'raises error if token does not exist' do
        user_token = build(:user_token)

        expect do
          described_class.burn!(user_id: user_token.user_id, kind: user_token.kind,
                                code: user_token.code)
        end.to raise_error(Token::Invalid)
      end

      it 'raises error if token has already been used' do
        user_token = create(:user_token, :burned)

        expect do
          described_class.burn!(user_id: user_token.user_id, kind: user_token.kind,
                                code: user_token.code)
        end.to raise_error(Token::Invalid)
      end

      it 'raises error if token expired' do
        user_token = create(:user_token, :expired)

        expect do
          described_class.burn!(user_id: user_token.user_id, kind: user_token.kind,
                                code: user_token.code)
        end.to raise_error(Token::Invalid)
      end
    end
  end

  describe '#used?' do
    context 'when checking if token was used' do
      it 'returns true if used' do
        user_token = create(:user_token, :burned)

        response = described_class.used?(user_id: user_token.user_id, kind: user_token.kind,
                                         code: user_token.code)

        expect(response).to be_truthy
      end

      it 'reotrna false if not used' do
        user_token = create(:user_token)

        response = described_class.used?(user_id: user_token.user_id, kind: user_token.kind,
                                         code: user_token.code)

        expect(response).to be_falsy
      end

      it "return true if it doesn't exist" do
        user_token = build(:user_token)

        response = described_class.used?(user_id: user_token.user_id, kind: user_token.kind,
                                         code: user_token.code)

        expect(response).to be_truthy
      end
    end
  end
end
