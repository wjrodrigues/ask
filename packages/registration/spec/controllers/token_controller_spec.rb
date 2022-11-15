# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Controller::Token, type: :controller do
  describe '#POST - Create token' do
    let(:user) { create(:user) }

    context 'when the parameters are valid' do
      it 'creates token, return http :created status and empty body' do
        body = { kind: User::Token::KINDS[:SMS], user_id: user.id }

        post '/tokens', body.to_json, 'CONTENT_TYPE' => 'application/json'

        expected_token = User::Token.find_by(user_id: body[:user_id], kind: body[:kind])

        expect(expected_token).not_to be_nil
        expect(last_response.body).to be_empty
        expect(last_response.status).to eq(Controller::Response::REASONS[:CREATED])
      end
    end

    context 'when parameters are not valid' do
      it 'does not create token and returns http :UNPROCESSABLE_ENTITY status' do
        body = { kind: nil, user_id: user.id }

        post '/tokens', body.to_json, 'CONTENT_TYPE' => 'application/json'

        expected_token = User::Token.find_by(user_id: body[:user_id], kind: body[:kind])

        expect(expected_token).to be_nil
        expect(last_response.body).not_to be_empty
        expect(last_response.status).to eq(Controller::Response::REASONS[:UNPROCESSABLE_ENTITY])
      end
    end
  end

  describe '#POST - Validate token' do
    context 'when the token is valid' do
      it 'returns status http :OK' do
        user_token = create(:user_token, :sms)
        body = { kind: user_token.kind, user_id: user_token.user_id }

        post "/tokens/#{user_token.code}", body.to_json, 'CONTENT_TYPE' => 'application/json'

        expect(last_response.body).to be_empty
        expect(last_response.status).to eq(Controller::Response::REASONS[:OK])
      end
    end

    context 'when the token is invalid' do
      it 'returns error message and status http :UNPROCESSABLE_ENTITY' do
        user_token = create(:user_token, :sms, expire_at: 1.day.ago)
        body = { kind: user_token.kind, user_id: user_token.user_id }

        post "/tokens/#{user_token.code}", body.to_json, 'CONTENT_TYPE' => 'application/json'

        expect(last_response.body).not_to be_empty
        expect(json_body(last_response.body)).to eq(['Token expired'])
        expect(last_response.status).to eq(Controller::Response::REASONS[:UNPROCESSABLE_ENTITY])
      end
    end
  end

  describe '#PATCH - Burn token' do
    context 'when the token is valid' do
      it 'updates used_at and return status http :OK' do
        user_token = create(:user_token, :sms)
        body = { kind: user_token.kind, user_id: user_token.user_id }

        patch "/tokens/#{user_token.code}", body.to_json, 'CONTENT_TYPE' => 'application/json'

        expect(user_token.reload.used_at).not_to be_nil
        expect(last_response.body).to be_empty
        expect(last_response.status).to eq(Controller::Response::REASONS[:OK])
      end
    end

    context 'when the token is invalid' do
      it 'returns error message and status http :UNPROCESSABLE_ENTITY' do
        user_token = create(:user_token, :sms, used_at: 1.day.ago)
        body = { kind: user_token.kind, user_id: user_token.user_id }

        patch "/tokens/#{user_token.code}", body.to_json, 'CONTENT_TYPE' => 'application/json'

        expect(last_response.body).not_to be_empty
        expect(json_body(last_response.body)).to eq(['Token has already been used'])
        expect(last_response.status).to eq(Controller::Response::REASONS[:UNPROCESSABLE_ENTITY])
      end
    end
  end
end
