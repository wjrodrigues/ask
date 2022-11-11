# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Service::CreatorUser, type: :service do
  describe '#call' do
    context 'when values are valid' do
      it 'returns response with created user' do
        response = described_class.call(
          profile: build(:profile, user: nil),
          email: Faker::Internet.email,
          password: Faker::Internet.password
        )

        expect(response.ok?).to be_truthy
        expect(response.result).to be_is_a(User)
      end
    end

    context 'when values are not valid' do
      it 'returns response with errors' do
        expected_errors =  [
          [:email, ["can't be blank", 'is invalid']],
          [:password, ["can't be blank", 'is too short (minimum is 8 characters)']]
        ]

        response = described_class.call(profile: nil, email: nil, password: nil)

        expect(response.ok?).to be_falsy
        expect(response.errors).to eq(expected_errors)
      end
    end
  end
end
