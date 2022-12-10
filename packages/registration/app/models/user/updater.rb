# frozen_string_literal: true

module User
  class Updater < Model::Application
    attr_accessor :params, :repository

    def initialize(params, repository: Repository)
      self.params = params
      self.repository = repository

      super
    end

    def call
      if repository.find(value: params.id).nil?
        return response.add_error(:'errors.messages.invalid')
      end

      result = repository.update(id: params.id, email: params.email, password: params.password)

      unless result
        response.add_error(
          repository.errors(email: params.email, password: params.password),
          translate: false
        )
      end

      response.add_result(repository.find(value: params.id))
    end

    private :params=, :repository
  end
end
