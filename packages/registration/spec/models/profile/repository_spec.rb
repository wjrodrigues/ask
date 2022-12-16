# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::Profile::Repository, type: :repository do
  describe '#errors' do
    context 'when to check if errors exists' do
      it 'returns hash with errors if exists' do
        response = described_class.errors(user_id: nil, first_name: nil, last_name: nil, photo: nil)
        expected_response = { first_name: ["can't be blank"], user: ["can't be blank"] }

        expect(response).to eq(expected_response)
      end

      it 'returns hash with errors if exists' do
        profile = create(:profile)
        response = described_class.errors(user_id: profile.user_id, first_name: profile.first_name)

        expect(response).to be_empty
      end
    end
  end

  describe '#update' do
    context 'when parameters are valid' do
      it 'returns true' do
        profile = build(:profile, user: create(:user))
        response = described_class.update(user_id: profile.user_id, first_name: profile.first_name)

        expect(response).to be_truthy
      end
    end

    context 'when parameters are invalid' do
      it 'returns false' do
        profile = build(:profile, user: create(:user))
        response = described_class.update(user_id: profile.user_id, first_name: nil)

        expect(response).to be_falsy
      end
    end
  end

  describe '#find' do
    context 'when parameter is id' do
      it 'returns the hash of profile' do
        profile = create(:profile)
        response = described_class.find(id: profile.id)

        expect(response).not_to be_nil
        expect(response).to be_is_a(Hash)
      end
    end

    context 'when parameter is user_id' do
      it 'returns the hash of profile' do
        profile = create(:profile)
        response = described_class.find(id: profile.user_id)

        expect(response).not_to be_nil
        expect(response).to be_is_a(Hash)
      end
    end

    context 'when the profile does not exist' do
      it 'returns empty hash' do
        response = described_class.find(id: 'ask')

        expect(response).to be_nil
      end
    end
  end
end
