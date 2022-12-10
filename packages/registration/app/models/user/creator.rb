# frozen_string_literal: true

module User
  class Creator < Model::Application
    attr_accessor :params, :repository

    def initialize(params, repository: Repository)
      self.params = params
      self.repository = repository

      super
    end

    def call
      values = { email: params.email, password: params.password }

      result = repository.create(**values)

      return response.add_result(repository.find(value: params.email)) if result

      response.add_error(repository.errors(**values), translate: false)
    end

    private :params=, :repository=
  end
end
