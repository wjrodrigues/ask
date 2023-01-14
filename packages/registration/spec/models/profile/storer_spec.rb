# frozen_string_literal: true

require 'spec_helper'

RSpec.describe ::Profile::Storer, type: :model do
  describe '#call' do
    let(:user) { create(:user) }

    context 'when values are valid' do
      it 'returns response with presigned url' do
        params = Controller::Request.call(
          extension: 'jpg', user_id: user.id, action: :presigned_url
        )
        response = described_class.call(params)

        expect(response.ok?).to be_truthy
        expect(response.result[:url]).to start_with("https://s3.amazonaws.com/profilePictures/#{user.id}.jpg")
      end
    end

    context 'when action are not valid' do
      it 'returns response with errors' do
        params = Controller::Request.call(extension: 'jpg', user_id: user.id, action: :upload)
        response = described_class.call(params)

        expect(response.ok?).not_to be_truthy
        expect(response.errors).to eq(['Unsupported action'])
      end
    end

    context 'when extension are not valid' do
      it 'returns response with errors' do
        params = Controller::Request.call(
          extension: 'mp4', user_id: user.id, action: :presigned_url
        )
        response = described_class.call(params)

        expect(response.ok?).not_to be_truthy
        expect(response.errors).to eq(['Unsupported extension'])
      end
    end
  end
end
