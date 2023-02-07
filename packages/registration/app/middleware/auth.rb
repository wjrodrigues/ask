# frozen_string_literal: true

module Middleware
  class Auth
    def self.check!(app, _token)

      app.halt Controller::Response::REASONS[:UNAUTHORIZED]
    end
  end
end
