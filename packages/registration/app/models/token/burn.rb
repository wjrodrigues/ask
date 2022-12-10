# frozen_string_literal: true

require 'securerandom'

module Token
  class Burn < Model::Application
    attr_accessor :params, :validator, :repository

    def initialize(params:, validator:, repository: Repository)
      self.params = params
      self.validator = validator
      self.repository = repository

      super
    end

    def call
      response_validator = validator.call(params)

      return response_validator unless response_validator.ok?

      values = { user_id: params.user_id, code: params.code, kind: params.kind }
      result = repository.burn!(**values)

      response.add_result(result)
    rescue StandardError
      response.add_error(:'errors.messages.invalid')
    end

    private :params=, :validator=, :repository=
  end
end
