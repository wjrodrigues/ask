# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Controller::User, type: :controller do
  describe '#POST - Create user' do
    context 'when the parameters are valid' do
      it 'creates user, return http :created status and empty body' do
        body = { email: Faker::Internet.email, password: Faker::Internet.password }

        expect(Lib::Auth).to receive(:create)
        expect(Lib::Messenger).to receive(:publish!)

        post '/users', body.to_json, 'CONTENT_TYPE' => 'application/json'

        expected_user = ::User::Record.find_by(email: body[:email])

        expect(expected_user).not_to be_nil
        expect(last_response.body).to be_empty
        expect(last_response.status).to eq(Controller::Response::REASONS[:CREATED])
      end
    end

    context 'when parameters are not valid' do
      it 'does not create user and returns http :UNPROCESSABLE_ENTITY status' do
        body = { email: Faker::Internet.email }

        post '/users', body.to_json, 'CONTENT_TYPE' => 'application/json'

        expected_user = ::User::Record.find_by(email: body[:email])

        expect(expected_user).to be_nil
        expect(last_response.body).not_to be_empty
        expect(last_response.status).to eq(Controller::Response::REASONS[:UNPROCESSABLE_ENTITY])
      end

      it 'returns errors in the body' do
        params = { last_name: Faker::Name.last_name }

        post '/users', params.to_json, 'CONTENT_TYPE' => 'application/json'

        expected_response = [{
          'email' => ["can't be blank", 'is invalid'],
          'password' => ["can't be blank", 'is too short (minimum is 8 characters)']
        }]

        expect(last_response.body).not_to be_empty
        expect(json_body(last_response.body)).to eq(expected_response)
      end
    end
  end

  describe '#PATCH - Update user' do
    context 'when the parameters are valid' do
      it 'updates email and return status http :OK' do
        user = create(:user)
        body = { email: Faker::Internet.email }

        patch "/users/#{user.id}", body.to_json, 'CONTENT_TYPE' => 'application/json'

        expected_user = ::User::Record.find_by(email: body[:email])

        expect(expected_user).not_to be_nil
        expect(last_response.body).to be_empty
        expect(last_response.status).to eq(Controller::Response::REASONS[:OK])
      end
    end

    context 'when invalid user' do
      it 'updates email and return status http :OK' do
        id = '6782e790-6b26-4e37-8cd7-10c3b6c99452'

        patch "/users/#{id}", {}.to_json, 'CONTENT_TYPE' => 'application/json'

        expect(last_response.body).not_to be_empty
        expect(json_body(last_response.body)).to eq(['is invalid'])
        expect(last_response.status).to eq(Controller::Response::REASONS[:UNPROCESSABLE_ENTITY])
      end
    end
  end

  describe '#POST - Create user' do
    context 'when the parameters are valid' do
      it 'updates profile, return http :created status and empty body' do
        user = create(:user)
        profile = { first_name: Faker::Name.first_name, last_name: Faker::Name.last_name }

        post "/users/#{user.id}/profile", profile.to_json, 'CONTENT_TYPE' => 'application/json'

        expected_profile = ::Profile::Record.find_by(user_id: user.id)

        expect(expected_profile).not_to be_nil
        expect(last_response.body).to be_empty
        expect(last_response.status).to eq(Controller::Response::REASONS[:OK])
      end
    end

    context 'when parameters are not valid' do
      it 'does not update profile and returns http :UNPROCESSABLE_ENTITY status' do
        user = create(:user)
        params = { last_name: Faker::Name.last_name }

        post "/users/#{user.id}/profile", params.to_json, 'CONTENT_TYPE' => 'application/json'

        expected_response = [{ 'first_name' => ["can't be blank"] }]

        expect(user.reload.profile).to be_nil
        expect(json_body(last_response.body)).to eq(expected_response)
        expect(last_response.status).to eq(Controller::Response::REASONS[:UNPROCESSABLE_ENTITY])
      end
    end
  end

  describe '#POST - Presigned URL' do
    let(:user) { create(:user) }

    context 'when the parameters are valid' do
      it 'returns URL and http :OK' do
        params = { action: :presigned_url, extension: 'jpeg' }.to_json

        post "/users/#{user.id}/profile/presigned_url", params, 'CONTENT_TYPE' => 'application/json'

        expected = "https://s3.amazonaws.com/profilepictures/#{user.id}.jpeg"

        expect(last_response.body).to start_with(expected)
        expect(last_response.status).to eq(Controller::Response::REASONS[:OK])
      end
    end

    context 'when extension are not valid' do
      it 'returns errors and http :UNPROCESSABLE_ENTITY status' do
        params = { action: :presigned_url, extension: 'mp4' }.to_json

        post "/users/#{user.id}/profile/presigned_url", params, 'CONTENT_TYPE' => 'application/json'

        expect(last_response.body).to eq('Unsupported extension')
        expect(last_response.status).to eq(Controller::Response::REASONS[:UNPROCESSABLE_ENTITY])
      end
    end

    context 'when action are not valid' do
      it 'returns errors and http :UNPROCESSABLE_ENTITY status' do
        params = { action: :upload, extension: 'png' }.to_json

        post "/users/#{user.id}/profile/presigned_url", params, 'CONTENT_TYPE' => 'application/json'

        expect(last_response.body).to eq('Unsupported action')
        expect(last_response.status).to eq(Controller::Response::REASONS[:UNPROCESSABLE_ENTITY])
      end
    end
  end

  describe '#POST - Auth user' do
    context 'when the parameters are valid' do
      it 'returns http :OK status and token in body' do
        user = create(:user)
        params = { username: user.email, password: user.password }

        expect(Lib::Auth::Keycloak).to receive(:client).and_return({ access_token: 'ask#1!2%3' })

        post '/users/auth', params.to_json, 'CONTENT_TYPE' => 'application/json'

        expect(json_body(last_response.body)).to eq({ 'access_token' => 'ask#1!2%3' })
        expect(last_response.status).to eq(Controller::Response::REASONS[:OK])
      end
    end

    context 'when parameters are not valid' do
      it 'returns http :UNAUTHORIZED status and error message in body' do
        user = create(:user)
        params = { username: user.email, password: user.password }

        expect(Lib::Auth::Keycloak).to receive(:client).and_return(false)

        post '/users/auth', params.to_json, 'CONTENT_TYPE' => 'application/json'

        expect(json_body(last_response.body)).to eq(['Invalid username or password'])
        expect(last_response.status).to eq(Controller::Response::REASONS[:UNAUTHORIZED])
      end
    end
  end
end
