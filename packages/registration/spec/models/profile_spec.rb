# frozen_string_literal: true

require 'spec_helper'

RSpec.describe User::Profile, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:first_name) }
    it { should validate_presence_of(:user) }
  end
end
