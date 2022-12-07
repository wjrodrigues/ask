# frozen_string_literal: true

module User
  class Creator < Model::Application
    attr_accessor :params

    def initialize(params)
      self.params = params

      super
    end

    def call
      user = ::User::Record.new(email: params.email,
                                password: params.password,
                                profile: instance_profile(params))

      return response.add_result(user) if user.save

      response.add_error(user.errors.messages, translate: false) unless user.valid?

      response
    end

    private :params=

    def instance_profile(params)
      return if params.first_name.nil?

      ::Profile::Record.new(first_name: params.first_name,
                            last_name: params.last_name,
                            photo: params.photo)
    end
  end
end
