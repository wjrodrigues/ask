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
          expect_any_instance_of(Lib::Auth::Keycloack).to receive(:reset_password).and_return(true)

          params = {
            first_name: 'Derek',
            last_name: 'Harber',
            password: 'YzQgQmRmB2xD9f',
            email: 'billie_harvey@bauch-hills.info',
            target: :keycloack
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
            target: :keycloack
          }

          VCR.use_cassette('auth/keycloak/create_user_invalid') do
            expect(Lib::Auth.create(**params)).to eq({ create: false, reset: nil })
          end
        end
      end
    end
  end
end
