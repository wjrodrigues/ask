# frozen_string_literal: true

module User
  class Auth < Model::Application
    attr_accessor :params, :repository, :auth

    def initialize(params, auth: Lib::Auth, repository: Repository)
      self.params = params
      self.repository = repository
      self.auth = auth

      super
    end

    def call
      return response.add_error(:'models.user.auth.errors.invalid') if params.username.nil?

      user = repository.find(value: params.username)

      return response.add_error(:'models.user.auth.errors.invalid') if user.nil?

      token = auth.client(username: params.username, password: params.password)

      return response.add_error(:'models.user.auth.errors.invalid') unless token

      response.add_result(token)
    end

    private :params=, :repository=, :auth=
  end
end
