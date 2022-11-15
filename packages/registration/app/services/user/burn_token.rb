# frozen_string_literal: true

require 'securerandom'

module Service
  class BurnToken < Service::Application
    attr_accessor :params, :validator

    def initialize(params, validator)
      self.params = params
      self.validator = validator

      super
    end

    def call
      response_validator = validator.call(params)
      return response_validator unless response_validator.ok?

      user_token = User::Token.where(user_id: params.user_id, kind: params.kind).last

      return response.add_result(true) if user_token.update(used_at: DateTime.current)

      response.add_error(:'errors.messages.invalid')
    end

    private :params=, :validator=
  end
end
