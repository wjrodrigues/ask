# frozen_string_literal: true

module Lib
  class Storage::S3
    def self.build_client
      Aws::S3::Client.new(force_path_style: true)
    end

    def self.presigned_url(folder_name:, file_name:)
      presigned = Aws::S3::Presigner.new(client: build_client)

      presigned.presigned_url(:put_object, bucket: folder_name, key: file_name)
    end
  end
end
