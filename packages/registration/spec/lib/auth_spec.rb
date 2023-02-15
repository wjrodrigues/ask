# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lib::Auth, type: :lib do
  let(:fake_access_token) { Faker::Alphanumeric.alpha }

  describe '#create' do
    context 'when the target is not supported' do
      it 'raises error with message' do
        params = { first_name: '', last_name: '', password: '', email: '', target: :okta }

        expect do
          Lib::Auth.create(**params)
        end.to raise_error(NotImplementedError, 'okta unsupported')
      end
    end

    context 'when the target is keycloak' do
      before { expect(Lib::Cache).to receive(:fetch).and_return(fake_access_token) }

      context 'and parameters are valid' do
        it 'returns true' do
          expect_any_instance_of(Lib::Auth::Keycloak).to receive(:reset_password).and_return(true)

          params = {
            first_name: 'Derek',
            last_name: 'Harber',
            password: 'YzQgQmRmB2xD9f',
            email: 'billie_harvey@bauch-hills.info',
            target: :keycloak
          }

          VCR.use_cassette('auth/keycloak/create_user') do
            expect(Lib::Auth.create(**params)).to eq({ create: true, reset: true })
          end
        end
      end

      context 'and parameters are invalid' do
        it 'returns false' do
          params = {
            first_name: 'Derek',
            last_name: 'Harber',
            password: 'YzQgQmRmB2xD9f',
            email: '',
            target: :keycloak
          }

          VCR.use_cassette('auth/keycloak/create_user_invalid') do
            expect(Lib::Auth.create(**params)).to eq({ create: false, reset: nil })
          end
        end
      end
    end
  end

  describe '#client' do
    context 'when username and password are valid' do
      it 'returns token' do
        params = { username: 'billie_harvey@bauch-hills.info', password: 'YzQgQmRmB2xD9f' }

        VCR.use_cassette('auth/keycloak/client') do
          expect(Lib::Auth.client(**params)).to be_truthy
        end
      end
    end

    context 'when username and password are invalid' do
      it 'returns false' do
        params = { username: 'billie@bauch.info', password: 'YzQgQmRmB2xD9f2' }

        VCR.use_cassette('auth/keycloak/client_invalid') do
          expect(Lib::Auth.client(**params)).to be_falsy
        end
      end
    end
  end

  describe '#valid_token?' do
    context 'when the token is not formatted' do
      it 'returns false' do
        token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.Et9HFtf9R3GEMA0IICOfFMVXY7kkTX1wr4qCyhIf'

        VCR.use_cassette('auth/keycloak/certificates') do
          expect(described_class.valid_token?(token)).to be_falsy
        end
      end
    end

    context 'when the token is formatted' do
      let(:token) { File.read('spec/lib/auth/token.txt') }

      it 'returns false when expired' do
        VCR.use_cassette('auth/keycloak/certificates') do
          expect(described_class.valid_token?(token)).to be_falsy
        end
      end

      it 'returns true' do
        VCR.use_cassette('auth/keycloak/certificates') do
          result = described_class.valid_token?(token, validate_expired: false)

          expect(result).to be_truthy
        end
      end

      it 'sets cache' do
        token = File.read('spec/lib/auth/token.txt')
        key_cache = 'certificate_keycloak_validation_token'

        allow(Redis).to receive(:new).and_return(double(get: nil, set: nil))
        expect(Lib::Cache).to receive(:fetch).with(key_cache).and_return(nil)
        expect(Lib::Cache).to receive(:fetch).with(key_cache, expires_in: 1500).and_call_original

        VCR.use_cassette('auth/keycloak/certificates') do
          described_class.valid_token?(token, validate_expired: false)
        end
      end
    end
  end

  describe '#decode_token' do
    let(:token) { '123' }

    context 'when the token is not formatted' do
      it 'returns false' do
        expect(Lib::Auth).to receive(:valid_token?).and_return(false)
        expect(described_class.decode_token(token)).to be_falsy
      end
    end

    context 'when the token is formatted' do
      it 'returns true' do
        expect(Lib::Auth).to receive(:valid_token?).and_return(
          [{ 'email' => 'billie_harvey@bauch-hills.info', 'any' => true }]
        )

        result = described_class.decode_token(token, validate_expired: false)

        expect(result).to eq({ 'email' => 'billie_harvey@bauch-hills.info' })
      end
    end
  end
end
