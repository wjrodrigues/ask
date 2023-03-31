# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Profile::Lister, type: :model do
  describe '#call' do
    context 'when the user has profile' do
      it 'returns hash with data' do
        profile = create(:profile)
        expected = {
          id: profile.id,
          first_name: profile.first_name,
          last_name: profile.last_name,
          photo: nil,
          created_at: profile.created_at,
          updated_at: profile.updated_at,
          user_id: profile.user_id
        }

        response = described_class.call(user_id: profile.user_id)

        expect(response.ok?).to be_truthy
        expect(response.result).to eq(expected)
      end
    end

    context 'when the user has no profile' do
      it 'returns empty hash' do
        user = create(:user)

        response = described_class.call(user_id: user.id)

        expect(response.ok?).to be_truthy
        expect(response.result).to eq({})
      end
    end
  end
end
