# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lib::Auth::Keycloack, type: :lib do
  let(:key_cache) { 'auth_keycloack_access_token' }
  let(:fake_access_token) { Faker::Alphanumeric.alpha }

  describe '#new' do
    context 'when instance' do
      it 'sets access token in cache' do
        require 'jwt'
hmac_secret = <<~EOS
-----BEGIN PUBLIC KEY-----
MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAxFNJtW+10y1TgK0D6zP+fscsAUrPz32g77NdOm/PefElKJP06vD5fKH9gCFHRYfa8B9m+S365e5J90LJBT1Riqeb8DDNaaOnBSE+ZR3Gm3/pV23A2V5eHi802mnDmQNMvqBz2tHqj8mExzVv1tONshakGd0iFcBDmDeQ7A351h1YFBhByucLVeLqvHDWR+ghRoR/0zdSmpY9hbNYNs4cG2H8kGAjh7+DcItqy5JmiwS+tAv9in3tN6Njon5Ynol/rws5TdW9erSMCL0MZPq2t8aIsFbZFw3q33EouJEJqPpBk6K3SpopG/RGR1gv1/38PcgkKSX6zlg6vei21rRE+wIDAQAB
-----END PUBLIC KEY-----
EOS
eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIzemtzbVpJV3BaN2hXRnNQT0JmQXZnal9INkFNb0QzWXBGZzYtRFQyV0QwIn0.eyJleHAiOjE2NzQ3ODM2MDUsImlhdCI6MTY3NDc4MTgwNSwianRpIjoiZDc0Y2QxM2ItZjdjYS00MzNlLWIyNDUtNmM1NWFkYmE2MWMyIiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL3JlYWxtcy9hc2siLCJhdWQiOiJyZWFsbS1tYW5hZ2VtZW50Iiwic3ViIjoiNjQ3YjI4ZTYtZmE2Ni00NzQzLWJlYWUtNzAyZDYzMTUyMThjIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiYXNrLWFwaS1jbGllbnQiLCJhY3IiOiIxIiwicmVzb3VyY2VfYWNjZXNzIjp7InJlYWxtLW1hbmFnZW1lbnQiOnsicm9sZXMiOlsibWFuYWdlLXVzZXJzIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwiY2xpZW50SG9zdCI6IjE5Mi4xNjguNDguMSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiY2xpZW50SWQiOiJhc2stYXBpLWNsaWVudCIsInByZWZlcnJlZF91c2VybmFtZSI6InNlcnZpY2UtYWNjb3VudC1hc2stY2xpZW50IiwiY2xpZW50QWRkcmVzcyI6IjE5Mi4xNjguNDguMSJ9.JixUAvLPSUCig5zKhOe6ZjjcW_KoPsJZ1LrzbH2EDFG2KHxTKNUeDzbvlDVFVa-9S4VScy6rOsdSA5s-yb5F1WauvYaIhJubIY0576dlLOCrlX7KyHZP5fpKtdA6BqrzsbFiiTOFEsz9MWW9ZlgvKynooGARYteVVWmd-QzrOOLVIgHSp-Ckl_7R41UtOwmjnDH1HlqPehoxNP4CyZIpP7lX6Tsd1bQdJFZv6eE2p_cXiJRENKoZHpCD6vOYJm1BG-Loa-sxw3UISGYLLrjNXAhY8LuDxxuU17zHkTrXd2tgo-4q-AQYOjXEffJGJdpzkXr7PKWuo42M4DALGbberw
        #public_key = OpenSSL::X509::Certificate.new(hmac_secret)
        public_key = OpenSSL::PKey::RSA.new(hmac_secret)
        token = 'eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIzemtzbVpJV3BaN2hXRnNQT0JmQXZnal9INkFNb0QzWXBGZzYtRFQyV0QwIn0.eyJleHAiOjE2NzQ3ODU4MTQsImlhdCI6MTY3NDc4NDAxNCwianRpIjoiN2NiMjg0MmUtOTI2OS00NzA1LWE3YzUtZWZiNTgzN2I4ZWI5IiwiaXNzIjoiaHR0cDovL2xvY2FsaG9zdDo4MDgwL3JlYWxtcy9hc2siLCJhdWQiOiJyZWFsbS1tYW5hZ2VtZW50Iiwic3ViIjoiNjQ3YjI4ZTYtZmE2Ni00NzQzLWJlYWUtNzAyZDYzMTUyMThjIiwidHlwIjoiQmVhcmVyIiwiYXpwIjoiYXNrLWFwaS1jbGllbnQiLCJhY3IiOiIxIiwicmVzb3VyY2VfYWNjZXNzIjp7InJlYWxtLW1hbmFnZW1lbnQiOnsicm9sZXMiOlsibWFuYWdlLXVzZXJzIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwiY2xpZW50SG9zdCI6IjE5Mi4xNjguNDguMSIsImVtYWlsX3ZlcmlmaWVkIjpmYWxzZSwiY2xpZW50SWQiOiJhc2stYXBpLWNsaWVudCIsInByZWZlcnJlZF91c2VybmFtZSI6InNlcnZpY2UtYWNjb3VudC1hc2stY2xpZW50IiwiY2xpZW50QWRkcmVzcyI6IjE5Mi4xNjguNDguMSJ9.KVyI989GbWTRH0bUts7oJ8tkBskRl1QZ9uV2szTddD5tmDqK8M985KjWWzA7DzmhO68LjjLJvr02elzdgJjxvfKzh-CL3yb6ys7AU9J4o9Y_x0uBXOB84ozJhHOxWGK2F41Oizz2YvSZBRmvTp6x6lS4dDSr9bSIzmYcGth8OOCVwYL1kpQmZlD91dP6vLJlt4i0iYlHxsLZetoGLrZ3Q0Glz_OAsiwpRJYri_dS6odmoSFD07_eu-1QUCEQe201JvtLmuLZ0U6PZ6rG5VDQFwk2ZDWRqCx0mPskRAeuURjOaVOoHmXZF91Vi6uLBpe4ayKDGB6vyxT-UzBoKm1Giw'
        binding.pry
        decoded_token = JWT.decode(token, public_key, true, { algorithm: 'RS256' })
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

  describe '#client' do
    context 'when params are valid' do
      it 'returns access token' do
        params = { username: 'billie_harvey@bauch-hills.info', password: 'YzQgQmRmB2xD9f' }

        VCR.use_cassette('auth/keycloak/client') do
          response = described_class.client(**params)

          expect(response.keys).to match(
            %w[access_token expires_in refresh_expires_in refresh_token token_type
               not-before-policy session_state scope]
          )
        end
      end
    end

    context 'when params are invalid' do
      it 'returns false' do
        params = { username: 'billie@bauch.info', password: 'YzQgQmRmB2xD9f2' }

        VCR.use_cassette('auth/keycloak/client_invalid') do
          response = described_class.client(**params)

          expect(response).to be_falsy
        end
      end
    end
  end
end
