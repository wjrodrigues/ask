# frozen_string_literal: true

module Service
  class CreatorUser < Service::Application
    attr_accessor :profile, :email, :password

    def initialize(profile:, email:, password:)
      self.profile = profile
      self.email = email
      self.password = password

      super
    end

    def call
      user = User.new(email:, profile:, password:)

      if user.valid?
        user.save!

        return response.add_result(user)
      end

      user.errors.messages.each { |msg| response.add_error(msg, translate: false) }

      response
    end

    private :profile=, :email=, :password=
  end
end
