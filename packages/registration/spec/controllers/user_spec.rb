# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Controller::User, type: :controller do
  describe '#POST - Create user' do
    let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => '123' } }

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
    let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => '123' } }
    let(:user) { create(:user) }

    context 'when not authenticated' do
      it 'returns http :UNAUTHORIZED status and empty body' do
        allow(Lib::Auth).to receive(:valid_token?).and_return(false)

        patch '/users', {}.to_json, headers

        expect(last_response.status).to eq(Controller::Response::REASONS[:UNAUTHORIZED])
        expect(last_response.body).to be_empty
      end
    end

    context 'when the parameters are valid' do
      it 'updates email and return status http :OK' do
        allow(Middleware::Auth).to receive(:check!)
        allow(Middleware::Auth).to receive(:current_user).and_return(user.slice(:id, :email))

        body = { email: Faker::Internet.email }

        patch '/users', body.to_json, headers

        expected_user = ::User::Record.find_by(email: body[:email])

        expect(expected_user).not_to be_nil
        expect(last_response.body).to be_empty
        expect(last_response.status).to eq(Controller::Response::REASONS[:OK])
      end
    end

    context 'when invalid user' do
      it 'does not update email and return status http :UNPROCESSABLE_ENTITY' do
        allow(Middleware::Auth).to receive(:check!)
        allow(Middleware::Auth)
          .to receive(:current_user)
          .and_return({ id: '6782e790-6b26-4e37-8cd7-10c3b6c99452', email: user.email })

        patch '/users', {}.to_json, headers

        expect(last_response.body).not_to be_empty
        expect(json_body(last_response.body)).to eq(['is invalid'])
        expect(last_response.status).to eq(Controller::Response::REASONS[:UNPROCESSABLE_ENTITY])
      end
    end
  end

  describe '#POST - Create profile' do
    let(:user) { create(:user) }
    let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => '123' } }

    context 'when not authenticated' do
      it 'returns http :unauthorized status and empty body' do
        allow(Lib::Auth).to receive(:valid_token?).and_return(false)

        post '/users/profile', {}.to_json, headers

        expect(last_response.status).to eq(Controller::Response::REASONS[:UNAUTHORIZED])
        expect(last_response.body).to be_empty
      end
    end

    context 'when the parameters are valid' do
      it 'updates profile, return http :created status and empty body' do
        allow(Middleware::Auth).to receive(:check!)
        allow(Middleware::Auth).to receive(:current_user).and_return(user.slice(:id, :email))

        profile = { first_name: Faker::Name.first_name, last_name: Faker::Name.last_name }

        post '/users/profile', profile.to_json, headers

        expected_profile = ::Profile::Record.find_by(user_id: user.id)

        expect(expected_profile).not_to be_nil
        expect(last_response.body).to be_empty
        expect(last_response.status).to eq(Controller::Response::REASONS[:OK])
      end
    end

    context 'when parameters are not valid' do
      it 'does not update profile and returns http :UNPROCESSABLE_ENTITY status' do
        allow(Middleware::Auth).to receive(:check!)
        allow(Middleware::Auth).to receive(:current_user).and_return(user.slice(:id, :email))

        params = { last_name: Faker::Name.last_name }

        post '/users/profile', params.to_json, headers

        expected_response = [{ 'first_name' => ["can't be blank"] }]

        expect(user.reload.profile).to be_nil
        expect(json_body(last_response.body)).to eq(expected_response)
        expect(last_response.status).to eq(Controller::Response::REASONS[:UNPROCESSABLE_ENTITY])
      end
    end
  end

  describe '#GET - List profile' do
    let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => '123' } }
    let(:profile) { create(:profile) }

    context 'when not authenticated' do
      it 'returns http :UNAUTHORIZED status and empty body' do
        expect(Lib::Auth).to receive(:valid_token?).and_return(false)

        get '/users/profile', {}.to_json, headers

        expect(last_response.status).to eq(Controller::Response::REASONS[:UNAUTHORIZED])
        expect(last_response.body).to be_empty
      end
    end

    context 'when the user has profile' do
      it 'returns hash with status http :OK' do
        expect(Middleware::Auth).to receive(:check!)
        expect(Middleware::Auth)
          .to receive(:current_user)
          .and_return(profile.user.slice(:id, :email))

        get '/users/profile', {}, headers

        expect(json_body(last_response.body)).to eq(profile.attributes.as_json)
        expect(last_response.status).to eq(Controller::Response::REASONS[:OK])
      end
    end

    context 'when the user no has profile' do
      it 'returns empty hash with status http :OK' do
        user = create(:user)

        expect(Middleware::Auth).to receive(:check!)
        expect(Middleware::Auth).to receive(:current_user).and_return(user.slice(:id, :email))

        get '/users/profile', {}, headers

        expect(last_response.body).not_to be_empty
        expect(json_body(last_response.body)).to eq({})
        expect(last_response.status).to eq(Controller::Response::REASONS[:OK])
      end
    end
  end

  describe '#POST - Presigned URL' do
    let(:user) { create(:user) }
    let(:headers) { { 'CONTENT_TYPE' => 'application/json', 'HTTP_AUTHORIZATION' => '123' } }

    context 'when not authenticated' do
      it 'returns http :unauthorized status and empty body' do
        allow(Lib::Auth).to receive(:valid_token?).and_return(false)

        post '/users/profile/presigned_url', {}.to_json, headers

        expect(last_response.status).to eq(Controller::Response::REASONS[:UNAUTHORIZED])
        expect(last_response.body).to be_empty
      end
    end

    context 'when the parameters are valid' do
      it 'returns URL and http :OK' do
        allow(Middleware::Auth).to receive(:check!)
        allow(Middleware::Auth).to receive(:current_user).and_return(user.slice(:id, :email))

        host = ENV.fetch('S3_ENDPOINT', nil)
        params = { extension: 'jpeg' }.to_json

        post '/users/profile/presigned_url', params, headers

        expected = "#{host}/profilepictures/#{user.id}.jpeg"

        expect(last_response.body).to start_with(expected)
        expect(last_response.status).to eq(Controller::Response::REASONS[:OK])
      end
    end

    context 'when extension are not valid' do
      it 'returns errors and http :UNPROCESSABLE_ENTITY status' do
        allow(Middleware::Auth).to receive(:check!)
        allow(Middleware::Auth).to receive(:current_user).and_return(user.slice(:id, :email))

        params = { extension: 'mp4' }.to_json

        post '/users/profile/presigned_url', params, headers

        expect(last_response.body).to eq('Unsupported extension')
        expect(last_response.status).to eq(Controller::Response::REASONS[:UNPROCESSABLE_ENTITY])
      end
    end
  end

  describe '#POST - Auth user' do
    context 'when the parameters are valid' do
      it 'returns http :OK status and token in body' do
        user = create(:user)
        params = { username: user.email, password: user.password }

        expect(Lib::Auth).to receive(:client).and_return({ access_token: 'ask#1!2%3' })

        post '/users/auth', params.to_json, 'CONTENT_TYPE' => 'application/json'

        expect(json_body(last_response.body)).to eq({ 'access_token' => 'ask#1!2%3' })
        expect(last_response.status).to eq(Controller::Response::REASONS[:OK])
      end
    end

    context 'when parameters are not valid' do
      it 'returns http :UNAUTHORIZED status and error message in body' do
        user = create(:user)
        params = { username: user.email, password: user.password }

        expect(Lib::Auth).to receive(:client).and_return(false)

        post '/users/auth', params.to_json, 'CONTENT_TYPE' => 'application/json'

        expect(json_body(last_response.body)).to eq(['Invalid username or password'])
        expect(last_response.status).to eq(Controller::Response::REASONS[:UNAUTHORIZED])
      end
    end
  end
end
