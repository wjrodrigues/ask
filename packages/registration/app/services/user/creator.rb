# frozen_string_literal: true

module Service
  class CreatorUser < Service::Application
    attr_accessor :params

    def initialize(params)
      self.params = params

      super
    end

    def call
      user = User.new(email: params.try(:email),
                      password: params.try(:password),
                      profile: instance_profile(params))

      if user.valid?
        user.save!

        return response.add_result(user)
      end

      user.errors.messages.each { |msg| response.add_error(msg, translate: false) }

      response
    end

    private :params=

    def instance_profile(params)
      return if params.try(:first_name).nil?

      User::Profile.new(first_name: params.try(:first_name),
                        last_name: params.try(:last_name),
                        photo: params.try(:photo))
    end
  end
end
