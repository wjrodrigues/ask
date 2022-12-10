# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::User::Repository, type: :repository do
  describe '#create' do
    context 'when parameters are valid' do
      it 'returns true' do
        user = build(:user)

        response = described_class.create(email: user.email, password: user.password)

        expect(response).to be_truthy
      end

      it 'returns false if email exists' do
        user = create(:user)

        response = described_class.create(email: user.email, password: user.password)

        expect(response).to be_falsy
      end
    end

    context 'when parameters are invalid' do
      it 'returns false' do
        response = described_class.create(email: nil, password: nil)

        expect(response).to be_falsy
      end
    end
  end

  describe '#errors' do
    context 'when parameters are valid' do
      it 'returns empty hash' do
        user = build(:user)

        response = described_class.errors(email: user.email, password: user.password)

        expect(response).to be_empty
      end
    end

    context 'when parameters are invalid' do
      it 'returns hash with errors' do
        response = described_class.errors(email: nil, password: nil)
        expected_errors = {
          email: ["can't be blank", 'is invalid'],
          password: ["can't be blank", 'is too short (minimum is 8 characters)']
        }

        expect(response).to eq(expected_errors)
      end
    end
  end

  describe '#find' do
    context 'when parameter is id' do
      it 'returns the hash of user' do
        user = create(:user)

        response = described_class.find(value: user.id)

        expect(response).to be_is_a(Hash)
      end
    end

    context 'when parameter is email' do
      it 'returns the hash of user' do
        user = create(:user)

        response = described_class.find(value: user.email)

        expect(response).to be_is_a(Hash)
      end
    end

    context 'when user does not exist' do
      it 'returns nil' do
        response = described_class.find(value: '')

        expect(response).to be_nil
      end
    end
  end

  describe '#update' do
    context 'when parameter is valid' do
      it 'returns true' do
        user = create(:user)

        response = described_class.update(id: user.id, email: Faker::Internet.email)

        expect(response).to be_truthy
      end
    end

    context 'when parameter is invalid' do
      it 'returns false' do
        user = create(:user)

        response = described_class.update(id: user.id, email: '')

        expect(response).to be_falsy
      end
    end

    context 'when user does not exist' do
      it 'returns false' do
        response = described_class.update(id: '123')

        expect(response).to be_falsy
      end
    end
  end
end
