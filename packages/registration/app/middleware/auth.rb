# frozen_string_literal: true

module Middleware
  class Auth
    EXTRACT_REQUEST = ->(app, attr) { app.request.env[attr] }

    def self.check!(app)
      token = EXTRACT_REQUEST.call(app, 'HTTP_AUTHORIZATION')

      return if token.nil? || Lib::Auth.valid_token?(token)

      app.halt Controller::Response::REASONS[:UNAUTHORIZED]
    end

    def self.current_user(app)
      return if app.nil?

      return app.session['current_user'] unless app.session['current_user'].nil?

      auth_token = EXTRACT_REQUEST.call(app, 'HTTP_AUTHORIZATION')
      token = Lib::Auth.decode_token(auth_token)

      return unless token

      app.session['current_user'] = User::Repository.find(value: token['email']).slice(:id, :email)
    end

    private_constant :EXTRACT_REQUEST
  end
end
