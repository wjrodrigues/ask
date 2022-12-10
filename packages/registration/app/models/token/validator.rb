# frozen_string_literal: true

require 'securerandom'

module Token
  class Validator < Model::Application
    attr_accessor :params, :repository

    def initialize(params, repository: Repository)
      self.params = params
      self.repository = repository

      super
    end

    def call
      values = { user_id: params.user_id, kind: params.kind, code: params.code }

      return response.add_error(:'errors.messages.invalid') unless repository.valid?(**values)
      return response.add_error(:'models.token.validator.errors.used') if repository.used?(**values)
      if repository.expired?(**values)
        return response.add_error(:'models.token.validator.errors.expired')
      end

      response.add_result(true)
    end

    private :params=, :repository=
  end
end
