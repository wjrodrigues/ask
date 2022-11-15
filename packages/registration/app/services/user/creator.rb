# frozen_string_literal: true

module Service
  class CreatorUser < Service::Application
    attr_accessor :params

    def initialize(params)
      self.params = params

      super
    end

    def call
      user = User.new(email: params.email,
                      password: params.password,
                      profile: instance_profile(params))

      return response.add_result(user) if user.save

      user.errors.messages.each { |msg| response.add_error(msg, translate: false) }

      response
    end

    private :params=

    def instance_profile(params)
      return if params.first_name.nil?

      User::Profile.new(first_name: params.first_name,
                        last_name: params.last_name,
                        photo: params.photo)
    end
  end
end
