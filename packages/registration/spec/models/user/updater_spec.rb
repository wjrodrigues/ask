# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::User::Updater, type: :model do
  describe '#call' do
    context 'when values are valid' do
      it 'returns response with created user' do
        user = create(:user)
        params = Controller::Request.call(id: user.id, email: Faker::Internet.email)
        response = described_class.call(params)

        expect(response.ok?).to be_truthy
        expect(response.result).to be_is_a(Hash)
        expect(response.result[:email]).not_to eq(user.email)
      end
    end

    context 'when values are not valid' do
      it 'returns response with errors' do
        expected_errors = [{
          email: ['has already been taken'],
          password: ["can't be blank", 'is too short (minimum is 8 characters)']
        }]

        first_user, second_user = create_list(:user, 2)

        params = Controller::Request.call(id: first_user.id, email: second_user.email)
        response = described_class.call(params)

        expect(response.ok?).to be_falsy
        expect(response.errors).to eq(expected_errors)
      end
    end

    context 'when invalid user' do
      it 'returns response with errors' do
        params = Controller::Request.call(id: '6782e790-6b26-4e37-8cd7-10c3b6c99452')
        response = described_class.call(params)

        expect(response.ok?).to be_falsy
        expect(response.errors).to eq(['is invalid'])
      end
    end
  end
end
