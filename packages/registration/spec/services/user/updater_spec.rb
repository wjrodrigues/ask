# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Service::UpdaterUser, type: :service do
  describe '#call' do
    context 'when values are valid' do
      it 'returns response with created user' do
        user = create(:user)
        params = Struct.new(:id, :email).new(user.id, Faker::Internet.email)
        response = described_class.call(params)

        expect(response.ok?).to be_truthy
        expect(response.result).to be_is_a(User)
        expect(response.result.email).not_to eq(user.email)
      end
    end

    context 'when values are not valid' do
      it 'returns response with errors' do
        expected_errors =  [[:email, ['has already been taken']]]

        first_user, second_user = create_list(:user, 2)

        params = Struct.new(:id, :email).new(first_user.id, second_user.email)
        response = described_class.call(params)

        expect(response.ok?).to be_falsy
        expect(response.errors).to eq(expected_errors)
      end
    end

    context 'when invalid user' do
      it 'returns response with errors' do
        params = Struct.new(:id).new('6782e790-6b26-4e37-8cd7-10c3b6c99452')
        response = described_class.call(params)

        expect(response.ok?).to be_falsy
        expect(response.errors).to eq(['is invalid'])
      end
    end
  end
end
