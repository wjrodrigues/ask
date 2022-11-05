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
end
