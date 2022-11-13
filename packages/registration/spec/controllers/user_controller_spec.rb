# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Controller::User, type: :controller do
  describe '#POST' do
    context 'when the parameters are valid' do
      it 'creates user, return http :created status and empty body' do
        body = { email: Faker::Internet.email, password: Faker::Internet.password }

        post '/users', body.to_json, 'CONTENT_TYPE' => 'application/json'

        expected_user = User.find_by(email: body[:email])

        expect(expected_user).not_to be_nil
        expect(last_response.body).to be_empty
        expect(last_response.status).to eq(Controller::Response::REASONS[:CREATED])
      end
    end

    context 'when parameters are not valid' do
      it 'does not create user and returns http :UNPROCESSABLE_ENTITY status' do
        body = { email: Faker::Internet.email }

        post '/users', body.to_json, 'CONTENT_TYPE' => 'application/json'

        expected_user = User.find_by(email: body[:email])

        expect(expected_user).to be_nil
        expect(last_response.body).not_to be_empty
        expect(last_response.status).to eq(Controller::Response::REASONS[:UNPROCESSABLE_ENTITY])
      end

      it 'returns errors in the body' do
        post '/users', {}.to_json, 'CONTENT_TYPE' => 'application/json'

        expected_response = [
          ['email', ["can't be blank", 'is invalid']],
          ['password', ["can't be blank", 'is too short (minimum is 8 characters)']]
        ]

        expect(last_response.body).not_to be_empty
        expect(json_body(last_response.body)).to eq(expected_response)
      end
    end
  end
end
