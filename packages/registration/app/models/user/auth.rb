# frozen_string_literal: true

module User
  class Auth < Model::Application
    attr_accessor :params, :repository, :auth

    def initialize(params, auth: Lib::Auth::Keycloack, repository: Repository)
      self.params = params
      self.repository = repository
      self.auth = auth

      super
    end

    def call
      return response.add_error(:'models.user.auth.errors.invalid') if params.email.nil?

      user = repository.find(value: params.email)

      return response.add_error(:'models.user.auth.errors.invalid') if user.nil?

      token = auth.client(username: params.email, password: params.password)

      return response.add_error(:'models.user.auth.errors.invalid') unless token

      response.add_result(token)
    end

    private :params=, :repository=, :auth=
  end
end
