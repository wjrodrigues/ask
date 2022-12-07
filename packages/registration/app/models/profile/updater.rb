# frozen_string_literal: true

module Profile
  class Updater < Model::Application
    attr_accessor :params

    def initialize(params)
      self.params = params

      super
    end

    def call
      profile = ::Profile::Record.find_or_create_by(user_id: params.user_id)

      first_name = params.first_name
      last_name = params.last_name
      photo = params.photo

      profile.first_name = first_name unless first_name.nil?
      profile.last_name = last_name unless last_name.nil?
      profile.photo = photo unless photo.nil?

      return response.add_result(profile) if profile.save

      response.add_error(profile.errors.messages, translate: false) unless profile.valid?

      response
    end

    private :params=
  end
end
