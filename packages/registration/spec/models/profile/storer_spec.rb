# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::Profile::Storer, type: :model do
  describe '#call' do
    context 'when values are valid' do
      it 'returns response with presigned url' do
        user = create(:user)

        response = described_class.call(extension: 'jpg', user:, action: :presigned_url)

        expect(response.ok?).to be_truthy
        expect(response.result[:url]).to start_with("https://s3.amazonaws.com/profilePictures/#{user.id}.jpg")
      end
    end

    context 'when action are not valid' do
      it 'returns response with errors' do
        user = create(:user)

        response = described_class.call(extension: 'jpg', user:, action: :upload)

        expect(response.ok?).not_to be_truthy
        expect(response.errors).to eq(['Unsupported action'])
      end
    end

    context 'when extension are not valid' do
      it 'returns response with errors' do
        user = create(:user)

        response = described_class.call(extension: 'mp4', user:, action: :presigned_url)

        expect(response.ok?).not_to be_truthy
        expect(response.errors).to eq(['Unsupported extension'])
      end
    end
  end
end
