# frozen_string_literal: true

require 'securerandom'

module Service
  class CreatorToken < Service::Application
    attr_accessor :params

    def initialize(params)
      self.params = params

      super
    end

    def call
      user = User.find_by!(id: params.try(:user_id))
      user_token = User::Token.create(
        code:,
        kind: params.kind,
        expire_at: 24.hours.from_now,
        user:
      )

      return response.add_result(user_token) if user_token.save

      response.add_error(user_token.errors.messages, translate: false) unless user_token.valid?

      response
    rescue ActiveRecord::RecordNotFound
      response.add_error(:'errors.messages.invalid')
    end

    private :params=

    def code
      return if params.kind.nil?

      return SecureRandom.alphanumeric(6).upcase if params.kind.strip == 'sms'

      SecureRandom.alphanumeric(30)
    end
  end
end
