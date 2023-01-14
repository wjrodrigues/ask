# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Lib::Storage do
  describe '#presigned_url' do
    context 'when generate pre-signed URL' do
      it 'returns URL pre-signed' do
        expect(Lib::Storage::S3).to receive(:presigned_url)

        instance = described_class.new(folder_name: 'profilepictures')
        instance.presigned_url('image.png')
      end
    end
  end
end
