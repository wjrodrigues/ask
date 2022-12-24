# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lib::Auth::Keycloack, type: :lib do
  let(:key_cache) { 'auth_keycloack_access_token' }
  let(:fake_access_token) { Faker::Alphanumeric.alpha }

  describe '#new' do
    context 'when instance' do
      it 'sets access token in cache' do
        allow(Redis).to receive(:new).and_return(double(get: nil, set: nil))
        expect(Lib::Cache).to receive(:fetch).and_return(nil).and_call_original
        expect(Lib::Cache).to receive(:fetch).with(key_cache, expires_in: 1500).and_call_original

        VCR.use_cassette('auth/keycloak/access_token') { described_class.new }
      end

      it 'checks if access token is in cache' do
        expect(Lib::Cache).to receive(:fetch).and_return(fake_access_token)
        expect(Lib::Cache).not_to receive(:fetch).with(key_cache, expires_in: 1500)

        VCR.use_cassette('auth/keycloak/access_token') { described_class.new }
      end

      it 'raises if bad request' do
        expect(Lib::Request).to receive(:execute).and_return(double(code: 422))
        expect(Lib::Cache).to receive(:fetch).and_return(nil)

        expect { described_class.new }.to raise_error(StandardError, 'Keycloak request invalid')
      end

      it 'raises if any error' do
        expect(Lib::Cache).to receive(:fetch).and_raise(StandardError)

        expect { described_class.new }.to raise_error(StandardError, 'Keycloak request invalid')
      end
    end
  end

  describe '#find' do
    before { allow(Lib::Cache).to receive(:fetch).and_return(fake_access_token) }

    context 'when exists' do
      it 'returns hash' do
        email = 'billie_harvey@bauch-hills.info'

        VCR.use_cassette('auth/keycloak/find') do
          user = described_class.new.find(email)

          expect(user['email']).to eq(email)
          expect(user['username']).to eq(email)
        end
      end
    end

    context "when it doesn't exist" do
      it 'returns nil' do
        email = 'ask@ask.info'

        VCR.use_cassette('auth/keycloak/find_not_exists') do
          expect(described_class.new.find(email)).to be_nil
        end
      end
    end
  end

  describe '#reset_password' do
    before { allow(Lib::Cache).to receive(:fetch).and_return(fake_access_token) }

    context 'when user exists' do
      it 'returns true' do
        email = 'billie_harvey@bauch-hills.info'

        subject = described_class.new

        expect(subject)
          .to receive(:find)
          .and_return({ 'id' => 'dad9abdd-c4c2-4ff3-a9f3-1a7c1ee8c542' })

        VCR.use_cassette('auth/keycloak/reset_password') do
          response = subject.reset_password(email, Faker::Internet.password)
          expect(response).to be_truthy
        end
      end
    end

    context 'when user does not exist' do
      it 'returns false' do
        VCR.use_cassette('auth/keycloak/find_not_exists') do
          response = described_class.new.reset_password(
            'billie_harvey@bauch-hills.info', Faker::Internet.password
          )
          expect(response).to be_falsy
        end
      end
    end

    context 'when any error' do
      it 'returns false' do
        subject = described_class.new
        allow(subject).to receive(:find).and_raise(StandardError)

        response = subject.reset_password(
          'billie_harvey@bauch-hills.info', Faker::Internet.password
        )

        expect(response).to be_falsy
      end
    end
  end

  describe '#create' do
    before { allow(Lib::Cache).to receive(:fetch).and_return(fake_access_token) }

    context 'when params are valid' do
      it 'returns true and resets the password' do
        subject = described_class.new

        expect(subject).to receive(:reset_password).and_return(true)

        email = 'billie_harvey@bauch-hills.info'
        params = { first_name: 'Derek', last_name: 'Harber', password: 'YzQgQmRmB2xD9f', email: }

        VCR.use_cassette('auth/keycloak/create_user') do
          expect(subject.create(**params)).to eq({ create: true, reset: true })
        end
      end
    end

    context 'when params are valid' do
      it 'returns false' do
        params = { first_name: 'Derek', last_name: 'Harber', password: 'YzQgQmRmB2xD9f', email: '' }
        subject = described_class.new

        expect(subject).not_to receive(:reset_password)

        VCR.use_cassette('auth/keycloak/create_user_invalid') do
          expect(subject.create(**params)).to eq({ create: false, reset: nil })
        end
      end
    end
  end
end
