# frozen_string_literal: true

module Lib
  class Auth::Keycloak
    attr_reader :access_token, :grant_type

    EXPIRES_IN = 1500 # 25 minutes

    KEY_CACHE = {
      access_token: 'auth_keycloak_access_token',
      cert: 'certificate_keycloak_validation_token'
    }.freeze

    URL = lambda do |target|
      base_url = "#{ENV.fetch('KEYCLOAK_HOST')}:#{ENV.fetch('KEYCLOAK_PORT')}"
      realm = ENV.fetch('KEYCLOAK_AUTH_REALM')

      {
        access_token: "#{base_url}/realms/#{realm}/protocol/openid-connect/token",
        user: "#{base_url}/admin/realms/#{realm}/users",
        certs: "#{base_url}/realms/#{realm}/protocol/openid-connect/certs"
      }.fetch(target)
    end

    def initialize(grant_type: :client_credentials, with_access_token: true)
      @grant_type = grant_type.to_s

      access_token! if with_access_token
    end

    def valid_token?(token, validate_expired: true)
      certificate = nil
      raw_cert = Lib::Cache.fetch(KEY_CACHE[:cert])

      if raw_cert.nil?
        response = Lib::Request.execute(URL.call(:certs), method: :get)
        certificates = JSON.parse(response.body)
        certificate = certificates['keys'].find { |c| c['alg'] == 'RS256' }

        return false if certificate.nil?
      end

      raw_cert = Lib::Cache.fetch(KEY_CACHE[:cert], expires_in: EXPIRES_IN) do
        <<~CERT
          -----BEGIN CERTIFICATE-----
          #{certificate['x5c'].first}
          -----END CERTIFICATE-----
        CERT
      end

      certificate = OpenSSL::X509::Certificate.new(raw_cert)

      JWT.decode(token, certificate.public_key, validate_expired, { algorithm: 'RS256' })
    rescue StandardError
      false
    end

    def client(username:, password:)
      payload = {
        client_secret: ENV.fetch('KEYCLOAK_FRONTEND_SECRET'),
        client_id: ENV.fetch('KEYCLOAK_FRONTEND_CLIENT_ID'),
        grant_type: @grant_type,
        password:,
        username:
      }

      headers = { content_type: 'application/x-www-form-urlencoded' }

      response = Lib::Request.execute(URL.call(:access_token), method: :post, payload:, headers:)

      return false if response.code != 200

      JSON.parse(response.body)
    rescue StandardError
      false
    end

    def create(first_name:, last_name:, password:, email:)
      payload = {
        username: email,
        email:,
        enabled: true,
        firstName: first_name,
        lastName: last_name,
        emailVerified: true
      }.to_json

      response = Lib::Request.execute(
        URL.call(:user), method: :post, payload:, headers: auth_header
      )
      return { create: false, reset: nil } if response.code != 201

      { create: true, reset: reset_password(email, password) }
    rescue Lib::HttpError => e
      Lib::ErrorTracker.notify(e)

      { create: false, reset: nil }
    end

    def find(email)
      response = Lib::Request.execute(
        URL.call(:user), method: :get, headers: auth_header(options: { params: { email: } })
      )
      response = JSON.parse(response.body)

      return nil if response.empty?

      response.first
    rescue StandardError
      false
    end

    def reset_password(email, password)
      user = find(email)

      return false unless user

      url = "#{URL.call(:user)}/#{user['id']}/reset-password"
      payload = { temporary: false, type: 'password', value: password }.to_json

      response = Lib::Request.execute(url, method: :put, payload:, headers: auth_header).code
      response == 204
    rescue StandardError
      false
    end

    private_constant :KEY_CACHE, :EXPIRES_IN, :URL

    private

    def access_token!
      @access_token = Lib::Cache.fetch(KEY_CACHE[:access_token])

      return unless @access_token.nil?

      response = request_access_token!

      raise if response.code != 200

      Lib::Cache.fetch(KEY_CACHE[:access_token], expires_in: EXPIRES_IN) do
        @access_token = JSON.parse(response.body).fetch('access_token')
      end
    rescue StandardError => e
      Lib::ErrorTracker.notify(e)

      raise StandardError, 'Keycloak request invalid'
    end

    def request_access_token!
      payload = {
        client_secret: ENV.fetch('KEYCLOAK_SECRET'),
        client_id: ENV.fetch('KEYCLOAK_CLIENT_ID'),
        grant_type: @grant_type
      }

      headers = { content_type: 'application/x-www-form-urlencoded' }

      Lib::Request.execute(URL.call(:access_token), method: :post, payload:, headers:)
    end

    def auth_header(content_type: :json, options: {})
      { content_type:, authorization: "Bearer #{@access_token}" }.merge(options)
    end
  end
end
