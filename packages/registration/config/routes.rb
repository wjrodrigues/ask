# frozen_string_literal: true

class Routes < Sinatra::Base
  set :default_content_type, 'application/json'

  before { Location.define(request.env['HTTP_ACCEPT_LANGUAGE']) }

  post '/users' do
    Controller::User.post(request)
  end

  patch '/users/:id' do
    request.params.merge!(params)

    Controller::User.patch(request)
  end

  post '/users/:id/profile' do
    request.params.merge!(params)

    Controller::User.update_profile(request)
  end
end
