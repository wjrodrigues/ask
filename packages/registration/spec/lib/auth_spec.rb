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
end
