# frozen_string_literal: true

module User
  class Creator < Model::Application
    attr_accessor :params, :repository, :auth, :notification

    def initialize(params, repository: Repository, auth: Lib::Auth, notification: Lib::Messenger)
      self.params = params
      self.repository = repository
      self.auth = auth
      self.notification = notification

      super
    end

    def call
      values = { email: params.email, password: params.password }

      result = repository.create(**values)

      if result
        auth.create(**values, target: :keycloack)
        send_notification
        return response.add_result(repository.find(value: params.email))
      end

      response.add_error(repository.errors(**values), translate: false)
    end

    private :params=, :repository=, :auth=, :notification=

    def send_notification
      notification.publish!(
        message: { template: :welcome, email: params.email },
        exchange: 'notification',
        queue: 'email'
      )
    rescue StandardError => e
      Lib::ErrorTracker.notify(e)
    end
  end
end
