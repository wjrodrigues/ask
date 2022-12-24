# frozen_string_literal: true

module User
  class Creator < Model::Application
    attr_accessor :params, :repository, :auth

    def initialize(params, repository: Repository, auth: Lib::Auth)
      self.params = params
      self.repository = repository
      self.auth = auth

      super
    end

    def call
      values = { email: params.email, password: params.password }

      result = repository.create(**values)

      if result
        auth.create(**values, target: :keycloack)
        return response.add_result(repository.find(value: params.email))
      end

      response.add_error(repository.errors(**values), translate: false)
    end

    private :params=, :repository=, :auth=
  end
end
