# frozen_string_literal: true

module Service
  class UpdaterUser < Service::Application
    attr_accessor :params

    def initialize(params)
      self.params = params

      super
    end

    def call
      user = User.find_by!(id: params.id)

      email = params.email
      password = params.password

      user.email = email unless email.nil?
      user.password = password unless password.nil?

      return response.add_result(user) if user.save

      user.errors.messages.each { |msg| response.add_error(msg, translate: false) }

      response
    rescue StandardError
      response.add_error(:'errors.messages.invalid')
    end

    private :params=
  end
end
