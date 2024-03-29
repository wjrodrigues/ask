# frozen_string_literal: true

require 'sinatra/cross_origin'

class Routes < Sinatra::Base
  set :default_content_type, 'application/json'
  set :bind, '0.0.0.0'

  configure { enable :cross_origin }

  before do
    Location.define(request.env['HTTP_ACCEPT_LANGUAGE'])

    Cors.allow(response)
  end

  post '/users' do
    Controller::User.post(request)
  end

  patch '/users' do
    Middleware::Auth.check!(self)
    current_user = Middleware::Auth.current_user(self)

    request.params.merge!(params, 'id' => current_user[:id])

    Controller::User.patch(request)
  end

  post '/users/profile' do
    Middleware::Auth.check!(self)
    current_user = Middleware::Auth.current_user(self)

    request.params.merge!(params, 'id' => current_user[:id])

    Controller::User.update_profile(request)
  end

  get '/users/profile' do
    Middleware::Auth.check!(self)
    current_user = Middleware::Auth.current_user(self)

    Controller::User.profile(user_id: current_user[:id])
  end

  post '/users/profile/presigned_url' do
    Middleware::Auth.check!(self)
    current_user = Middleware::Auth.current_user(self)

    request.params.merge!(params, 'id' => current_user[:id])

    Controller::User.presigned_url(request)
  end

  post '/users/auth' do
    Controller::User.auth(request)
  end

  post '/tokens' do
    Controller::Token.post(request)
  end

  post '/tokens/:code' do
    request.params.merge!(params)

    Controller::Token.validate(request)
  end

  patch '/tokens/:code' do
    request.params.merge!(params)

    Controller::Token.burn(request)
  end

  options '*' do
    Cors.allow(response)
  end
end
