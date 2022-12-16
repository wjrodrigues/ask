# frozen_string_literal: true

module Profile
  class Updater < Model::Application
    attr_accessor :params, :repository

    def initialize(params, repository: Repository)
      self.params = params
      self.repository = repository

      super
    end

    def call
      values = {
        user_id: params.user_id,
        first_name: params.first_name,
        last_name: params.last_name,
        photo: params.photo
      }

      result = repository.update(**values)
      response.add_error(repository.errors(**values), translate: false) unless result

      response.add_result(repository.find(id: params.user_id))
    end

    private :params=, :repository=
  end
end
