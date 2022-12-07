# frozen_string_literal: true

require 'securerandom'

module Token
  class Validator < Model::Application
    attr_accessor :params

    def initialize(params)
      self.params = params

      super
    end

    def call
      user_token = ::Token::Record.where(user_id: params.user_id,
                                         kind: params.kind,
                                         code: params.code).last

      return response.add_error(:'errors.messages.invalid') if user_token.nil?
      return response.add_error(:'models.validator_token.errors.used') if user_token.used?
      return response.add_error(:'models.validator_token.errors.expired') if user_token.expired?

      response.add_result(true)
    end

    private :params=
  end
end
