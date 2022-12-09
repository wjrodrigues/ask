# frozen_string_literal: true

module User
  class Updater < Model::Application
    attr_accessor :params

    def initialize(params)
      self.params = params

      super
    end

    def call
      user = Record.find_by!(id: params.id)

      email = params.email
      password = params.password

      user.email = email unless email.nil?
      user.password = password unless password.nil?

      return response.add_result(user) if user.save

      response.add_error(user.errors.messages, translate: false) unless user.valid?

      response
    rescue StandardError
      response.add_error(:'errors.messages.invalid')
    end

    private :params=
  end
end
