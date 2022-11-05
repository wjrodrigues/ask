# frozen_string_literal: true

class Routes < Sinatra::Base
  set :default_content_type, 'application/json'

  get '/' do
    'Hello world!'
  end
end
