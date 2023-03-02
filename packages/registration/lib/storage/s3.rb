# frozen_string_literal: true

module Lib
  class Storage::S3
    def self.build_client
      params = { force_path_style: true }
      params[:endpoint] = ENV['S3_ENDPOINT'] if ENV['S3_ENDPOINT']

      Aws::S3::Client.new(params)
    end

    def self.presigned_url(folder_name:, file_name:)
      presigned = Aws::S3::Presigner.new(client: build_client)

      presigned.presigned_url(:put_object, bucket: folder_name, key: file_name)
    end
  end
end
