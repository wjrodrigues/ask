# frozen_string_literal: true

require 'securerandom'

module Service
  class ValidatorToken < Service::Application
    attr_accessor :params

    def initialize(params)
      self.params = params

      super
    end

    def call
      user_token = User::Token.where(user_id: params.user_id, kind: params.kind).last

      return response.add_error(:'errors.messages.invalid') if user_token.nil?
      return response.add_error(:'services.validator_token.errors.used') if user_token.used?
      return response.add_error(:'services.validator_token.errors.expired') if user_token.expired?

      response.add_result(true)
    end

    private :params=
  end
end
