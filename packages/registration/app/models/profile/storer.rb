# frozen_string_literal: true

module Profile
  class Storer < Model::Application
    ACTIONS = %i[presigned_url].freeze
    EXTENSIONS = %i[jpg jpeg png].freeze

    attr_accessor :params, :storage

    def initialize(params, storage: Lib::Storage)
      self.params = params
      self.storage = storage

      super
    end

    def call
      if params.action.nil? || !ACTIONS.include?(params.action.to_sym)
        return response.add_error(:'models.profile.storer.errors.unsupported_action')
      end

      response.add_result({ url: send(params.action.to_sym) })
    end

    private :params, :storage
    private_constant :ACTIONS, :EXTENSIONS

    def presigned_url
      if params.extension.nil? || !EXTENSIONS.include?(params.extension.to_sym)
        return response.add_error(:'models.profile.storer.errors.unsupported_extension')
      end

      storage_instance = storage.new(folder_name: 'profilePictures')
      file_name = "#{params.user_id}.#{params.extension}"

      storage_instance.presigned_url(file_name)
    end
  end
end
