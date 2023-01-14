# frozen_string_literal: true

module Profile
  class Storer < Model::Application
    ACTIONS = %i[presigned_url].freeze
    EXTENSIONS = %i[jpg jpeg png].freeze

    attr_accessor :extension, :user, :storage, :action

    def initialize(extension:, user:, action:, storage: Lib::Storage)
      self.extension = extension
      self.user = user
      self.storage = storage
      self.action = action

      super
    end

    def call
      if action.nil? || !ACTIONS.include?(action.to_sym)
        return response.add_error(:'models.profile.storer.errors.unsupported_action')
      end

      response.add_result({ url: send(action.to_sym) })
    end

    private :extension=, :user=, :storage=, :action=
    private_constant :ACTIONS, :EXTENSIONS

    def presigned_url
      if extension.nil? || !EXTENSIONS.include?(extension.to_sym)
        return response.add_error(:'models.profile.storer.errors.unsupported_extension')
      end

      storage_instance = storage.new(folder_name: 'profilePictures')
      file_name = "#{user.id}.#{extension}"

      storage_instance.presigned_url(file_name)
    end
  end
end
