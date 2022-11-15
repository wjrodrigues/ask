# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Service::UpdaterProfile, type: :service do
  describe '#call' do
    context 'when values are valid' do
      it 'returns response with created user' do
        user = create(:user)
        params = Controller::Request.call(
          user_id: user.id,
          first_name: Faker::Name.first_name,
          last_name: Faker::Name.last_name,
          photo: Faker::Internet.url
        )

        response = described_class.call(params)

        expect(response.ok?).to be_truthy
        expect(response.result).to be_is_a(User::Profile)
      end
    end

    context 'when values are not valid' do
      it 'returns response with errors' do
        user = create(:user)
        params = Controller::Request.call(user_id: user.id)

        response = described_class.call(params)

        expect(response.ok?).not_to be_truthy
        expect(response.errors).to eq([[:first_name, ["can't be blank"]]])
      end
    end

    context 'when invalid user' do
      it 'returns response with errors' do
        params = Controller::Request.call(user_id: '6782e790-6b26-4e37-8cd7-10c3b6c99452')
        expected_errors = [[:first_name, ["can't be blank"]], [:user, ["can't be blank"]]]

        response = described_class.call(params)

        expect(response.ok?).to be_falsy
        expect(response.errors).to eq(expected_errors)
      end
    end
  end
end
