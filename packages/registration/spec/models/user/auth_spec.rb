# frozen_string_literal: true

require 'spec_helper'

RSpec.describe User::Auth, type: :model do
  describe '#call' do
    context 'when email is invalid' do
      it 'returns response with error message' do
        params = Controller::Request.call({ password: Faker::Internet.password })

        response = described_class.call(params)

        expect(response.ok?).not_to be_truthy
        expect(response.errors).to eq(['Invalid username or password'])
      end
    end

    context 'when password is invalid' do
      it 'returns response with error message' do
        password = Faker::Internet.password
        user = create(:user, password:)

        params = Controller::Request.call({ username: user.email, password: })

        expect(Lib::Auth::Keycloak).to receive(:client).and_return(false)

        response = described_class.call(params)

        expect(response.ok?).to be_falsy
        expect(response.errors).to eq(['Invalid username or password'])
      end
    end

    context 'when user does not exist' do
      it 'returns response with error message' do
        params = Controller::Request.call(
          {
            email: Faker::Internet.email,
            password: Faker::Internet.password
          }
        )

        response = described_class.call(params)

        expect(response.ok?).not_to be_truthy
        expect(response.errors).to eq(['Invalid username or password'])
      end
    end

    context 'when values are valid' do
      it 'returns response with token' do
        password = Faker::Internet.password
        user = create(:user, password:)

        params = Controller::Request.call({ username: user.email, password: })

        expected_token = Faker::Alphanumeric.alphanumeric

        expect(Lib::Auth::Keycloak)
          .to receive(:client)
          .and_return({ access_token: expected_token })

        response = described_class.call(params)

        expect(response.ok?).to be_truthy
        expect(response.result).to eq({ access_token: expected_token })
      end
    end
  end
end
