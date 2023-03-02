# frozen_string_literal: true

module Lib
  class Auth
    TARGETS = { keycloak: 'Lib::Auth::Keycloak' }.freeze
    GET_TARGET = lambda do |target|
      [target] => [Symbol]

      raise NotImplementedError, "#{target} unsupported" unless TARGETS.key?(target)

      TARGETS.fetch(target)
    end

    def self.create(password:, email:, target:, first_name: nil, last_name: nil)
      klass = GET_TARGET.call(target).constantize.new
      klass.create(first_name:, last_name:, password:, email:)
    end

    def self.client(username:, password:, target: :keycloak)
      klass = GET_TARGET.call(target).constantize.new(grant_type: :password, with_access_token: false)
      klass.client(username:, password:)
    end

    def self.valid_token?(token, validate_expired: true, target: :keycloak)
      klass = GET_TARGET.call(target).constantize.new(with_access_token: false)
      klass.valid_token?(token, validate_expired:)
    end

    def self.decode_token(token, validate_expired: true, target: :keycloak)
      token = valid_token?(token, validate_expired:, target:)

      return false unless token

      token.first.slice('email')
    end

    private_constant :TARGETS, :GET_TARGET
  end
end
