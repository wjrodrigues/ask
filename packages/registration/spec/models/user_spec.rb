# frozen_string_literal: true

require 'spec_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_one(:profile) }
  end

  describe 'validations' do
    subject { build(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
    it { expect(subject.valid?).to be_truthy }
  end

  describe '.before_save' do
    context 'when the password is valid' do
      context 'and unsaved user' do
        it 'encrypts password' do
          password = 123_456_789
          user = build(:user, password:)

          user.save!

          expect(user.password).not_to eq(password)
        end
      end

      context 'and change the password' do
        it 'encrypts new password' do
          user = create(:user)

          old_password = user.password
          user.update!(password: 123_456_789)

          expect(user.password).not_to eq(old_password)
        end
      end

      context 'and modify user without password' do
        it 'does not encrypt password' do
          user = create(:user)

          old_password = user.password
          user.update!(email: Faker::Internet.email)

          expect(user.password).to eq(old_password)
        end
      end
    end
  end
end
