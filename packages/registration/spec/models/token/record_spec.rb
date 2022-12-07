# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::Token::Record, type: :model do
  describe 'constants' do
    it { expect(described_class::KINDS).to eq({ SMS: 'sms', LOGIN: 'login', RESET: 'reset' }) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:code) }
    it { should validate_presence_of(:kind) }
    it { should validate_presence_of(:expire_at) }
    it { should validate_inclusion_of(:kind).in_array(%w[sms login reset]) }
  end

  describe 'alias_attribute' do
    it { expect(subject).to be_respond_to(:used?) }
  end

  describe '#burn!' do
    context 'when used_at is empty' do
      it 'updates used_at with current date' do
        user_token = create(:user_token)

        Timecop.freeze(Date.current) do
          user_token.burn!

          expect(user_token.used_at).to eq(DateTime.current)
        end
      end
    end

    context 'when used_at is not empty' do
      it 'raises ActiveRecord::RecordInvalid' do
        user_token = create(:user_token, used_at: Date.current)

        expect { user_token.burn! }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  describe '#expired?' do
    it 'returns true if the token has expired' do
      user_token = create(:user_token, expire_at: 1.day.ago)

      expect(user_token).to be_expired
    end

    it 'returns false if the token has not expired' do
      user_token = create(:user_token, expire_at: 1.day.from_now)

      expect(user_token).not_to be_expired
    end
  end
end
