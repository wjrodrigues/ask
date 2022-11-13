# frozen_string_literal: true

module Service
  class UpdaterProfile < Service::Application
    attr_accessor :params

    def initialize(params)
      self.params = params

      super
    end

    def call
      profile = User::Profile.find_or_create_by(user_id: params.try(:user_id))

      first_name = params.try(:first_name)
      last_name = params.try(:last_name)
      photo = params.try(:photo)

      profile.first_name = first_name unless first_name.nil?
      profile.last_name = last_name unless last_name.nil?
      profile.photo = photo unless photo.nil?

      return response.add_result(profile) if profile.save

      profile.errors.messages.each { |msg| response.add_error(msg, translate: false) }

      response
    end

    private :params=
  end
end
