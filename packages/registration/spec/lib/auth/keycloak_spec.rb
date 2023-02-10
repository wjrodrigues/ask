# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lib::Auth::Keycloack, type: :lib do
  let(:key_cache) { 'auth_keycloack_access_token' }
  let(:fake_access_token) { Faker::Alphanumeric.alpha }

  describe '#new' do
    context 'when instance' do
      it 'sets access token in cache' do
        #         require 'jwt'
        # certificate = <<~EOS
        # -----BEGIN CERTIFICATE-----
        # MIIClTCCAX0CBgGGLjuZVjANBgkqhkiG9w0BAQsFADAOMQwwCgYDVQQDDANhc2swHhcNMjMwMjA3MjMzMzIzWhcNMzMwMjA3MjMzNTAzWjAOMQwwCgYDVQQDDANhc2swggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDDHHu6UlbZ0EG/Av3EpLe/2ElMI4cXhcvUHV36XXottEmJTWXWyBKjKjIehWpG6Ui96FLsjy/NbP4ex6ncnhMR3Chz+txl5g2FrMw2YoBU+pA5wass9B4Bj8AY1jGzJqJmM+xVnDW3phLOqcFUMVehEn2+I1PqCizXhj5ytdFH02I8F6F65umNfe/7w1qirNg5uZIn01bbufHCq37dHX6RgeSFY25qJkLmQt++8NF/3Lir9w+cRaxKj6iOPDv1oKsKZq/50vWij6HD330TgXR2pjsIHHGabRGUFk2F9Buu0bQID9tZo9WWhSwLAvXEbCLLhBircZA2T5M79uEa8WvhAgMBAAEwDQYJKoZIhvcNAQELBQADggEBACEhqN/r8FwbajNn0pVBKWPLivdre6XmHtebT4pvxuq2ublgq7jlHmH/lByRMr8lvUjQDFI6TkQMNLXURtbXDGslOHg7AGdQWNwTigUVIrO4tDb1WB9yJwFr8n0BXA1Y7i+m8N/IMgbc8vMPuk8LZ7HQlemS2zHW/dv8e9tFdfoMI1mHhDs29xmUOPr90zOydnPpmhZ45CTxqihk9ZL4Tua7OgDeo+TFuLGSIzqlUdQKm6nLA7E2BqW/ECtXlXBll68K5e99HCTKEqa+RI0EohcnNbp5ThjJvkMKeC74NQCBtc3am2kAm7RYKtnPJIusgGSEwTod6p5wYzFrUx/awwU=
        # -----END CERTIFICATE-----
        # EOS
        # token = 'eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICI2RmsyZkpXVzc4Q2tIcHJzRWh2dDhNNlhjbmV6YWJ3cm5tRi01RUpDeTRzIn0.eyJleHAiOjE2NzU4MTkzMjUsImlhdCI6MTY3NTgxNzUyNSwianRpIjoiM2NiY2IzMGYtOGFkZS00YmI5LTk3ODktODAzMjAxM2U0OTgyIiwiaXNzIjoiaHR0cDovL2tleWNsb2FrOjgwODAvcmVhbG1zL2FzayIsImF1ZCI6ImFjY291bnQiLCJzdWIiOiI1ZGZjYzU1My1kNDc5LTQyOGUtYTcwOS04NjJiNGZiYjllYjciLCJ0eXAiOiJCZWFyZXIiLCJhenAiOiJhc2stZnJvbnRlbmQtY2xpZW50Iiwic2Vzc2lvbl9zdGF0ZSI6ImQzOGQ1NmMyLTQ0ZTEtNDViMi04YTFkLTM4MGNlODhlZWZjZiIsImFjciI6IjEiLCJyZWFsbV9hY2Nlc3MiOnsicm9sZXMiOlsiZGVmYXVsdC1yb2xlcy1hc2siLCJvZmZsaW5lX2FjY2VzcyIsInVtYV9hdXRob3JpemF0aW9uIl19LCJyZXNvdXJjZV9hY2Nlc3MiOnsiYWNjb3VudCI6eyJyb2xlcyI6WyJtYW5hZ2UtYWNjb3VudCIsIm1hbmFnZS1hY2NvdW50LWxpbmtzIiwidmlldy1wcm9maWxlIl19fSwic2NvcGUiOiJwcm9maWxlIGVtYWlsIiwic2lkIjoiZDM4ZDU2YzItNDRlMS00NWIyLThhMWQtMzgwY2U4OGVlZmNmIiwiZW1haWxfdmVyaWZpZWQiOnRydWUsInByZWZlcnJlZF91c2VybmFtZSI6ImJpbGxpZV9oYXJ2ZXlAYmF1Y2gtaGlsbHMuaW5mbyIsImVtYWlsIjoiYmlsbGllX2hhcnZleUBiYXVjaC1oaWxscy5pbmZvIn0.GWMGE3xrXcmL_IfRed-Uhu2-7R8no49PC5KHPF3jwZddnNbk1M1I30OGuZ9AWkppkjaWz5vtH9p_ljxU0FRol33a96A49r5_GCIUOQZBuxWM_Eniv7SVLGQqpZDl8K9ogIF9CHsc3YydRyTFMmxtUxIWRdx-iXqRjeVkszbpZGc3Kmfh_xrAFHRCXPkTuMlwkW7X0FTibj-v7FNzUritmsvGOAUVOhg0fyh2e45a5ADMmvXISRA47PF6GvTrHDrAmWl0PC1d6xUi5eJZaEqtwI1HwKI6DvYkWbFacfQm_KgsKiq0JIYrU5KtRpszspr6xqXs63N-eRHnPHw72VWkbQ'
        # #public_key = OpenSSL::PKey::RSA.new(hmac_secret)

        # certificate = OpenSSL::X509::Certificate.new(certificate)
        # binding.pry
        #         decoded_token = JWT.decode(token, certificate.public_key, true, { algorithm: 'RS256' })
        #         allow(Redis).to receive(:new).and_return(double(get: nil, set: nil))
        #         expect(Lib::Cache).to receive(:fetch).and_return(nil).and_call_original
        #         expect(Lib::Cache).to receive(:fetch).with(key_cache, expires_in: 1500).and_call_original

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

  describe '#valid_token?' do
    context 'when the token is not formatted' do
      it 'returns false' do
        token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.e30.Et9HFtf9R3GEMA0IICOfFMVXY7kkTX1wr4qCyhIf58U'

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
          expect(described_class.valid_token?(token, validate_expired: false)).to be_truthy
        end
      end
    end
  end
end
