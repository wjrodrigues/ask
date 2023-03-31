# frozen_string_literal: true

module Profile
  class Lister < Model::Application
    attr_accessor :user_id, :repository

    def initialize(user_id:, repository: Repository)
      self.user_id = user_id
      self.repository = repository

      super
    end

    def call
      result = repository.find(id: user_id)

      return response.add_result({}) unless result

      response.add_result(result)
    end

    private :user_id=, :repository=
  end
end
