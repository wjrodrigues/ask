# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::User::Creator, type: :model do
  describe '#call' do
    context 'when values are valid' do
      it 'returns response with created user' do
        params = Controller::Request.call(
          {
            email: Faker::Internet.email,
            password: Faker::Internet.password
          }
        )

        expect(Lib::Auth).to receive(:create)
        expect(Lib::Messenger).to receive(:publish!)

        response = described_class.call(params)

        expect(response.ok?).to be_truthy
        expect(response.result).to be_is_a(Hash)
      end

      context 'and generate error in notification' do
        it 'calls Lib::ErrorTracker#notify' do
          params = Controller::Request.call(
            {
              email: Faker::Internet.email,
              password: Faker::Internet.password
            }
          )

          allow(Lib::Auth).to receive(:create)
          expect(Lib::Messenger).to receive(:publish!).and_raise(StandardError)

          described_class.call(params)
        end
      end
    end

    context 'when values are not valid' do
      it 'returns response with errors' do
        expected_errors =  [{
          email: ['is invalid'],
          password: ["can't be blank", 'is too short (minimum is 8 characters)']
        }]

        params = Struct.new(:email, :password)
        response = described_class.call(params.new({ email: nil, password: nil }))

        expect(response.ok?).to be_falsy
        expect(response.errors).to eq(expected_errors)
      end
    end
  end
end
