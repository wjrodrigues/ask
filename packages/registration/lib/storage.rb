# frozen_string_literal: true

module Lib
  class Storage
    def initialize(folder_name:, client: Lib::Storage::S3)
      [folder_name] => [String | Symbol]

      @folder_name = folder_name
      @client = client
    end

    def presigned_url(file_name)
      @client.presigned_url(folder_name:, file_name:)
    end

    private

    attr_reader :folder_name, :client
  end
end
