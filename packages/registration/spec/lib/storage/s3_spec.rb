# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lib::Storage::S3 do
  describe '#presigned_url' do
    context 'when generate pre-signed URL' do
      it 'returns URL pre-signed' do
        host = ENV.fetch('S3_ENDPOINT', nil)
        url_presigned = described_class.presigned_url(
          folder_name: 'profilepictures', file_name: 'image.png'
        )

        expect(url_presigned).to start_with("#{host}/profilepictures/image.png")
      end
    end
  end
end
